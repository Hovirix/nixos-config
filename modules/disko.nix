{ username, config, ... }:
{
  # =================================================================================
  # Remote Disk Unlocking
  # =================================================================================

  boot.initrd = {
    availableKernelModules = [ "r8169" ];

    network = {
      enable = true;
      udhcpc.enable = true;
      flushBeforeStage2 = true;

      ssh = {
        port = 22;
        enable = true;
        hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
        authorizedKeys = config.users.users.${username}.openssh.authorizedKeys.keys;
      };

      postCommands = '' echo "cryptsetup-askpass" >> /root/.profile '';
    };
  };

  # =================================================================================
  # Rollback BTRFS root subvolume to a pristine state
  # =================================================================================

  boot.initrd.systemd.services.rollback = {
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-cryptsetup@crypted.service" ];
    before = [ "sysroot.mount" ];

    script =
      ''
        set -euo pipefail

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        mkdir /btrfs_tmp
        mount /dev/mapper/crypted /btrfs_tmp

        if btrfs subvolume show /btrfs_tmp/root > /dev/null 2>&1; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
  };

  # =================================================================================
  # Disko
  # =================================================================================

  disko.devices.disk = {

    # =================================================================================
    # NixOS
    # =================================================================================

    nixos = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_2000GB_24517E4ABM06";

      content = {
        type = "gpt";
        partitions = {

          # ------------------------------------------------------------------------------------------------
          # Boot
          # ------------------------------------------------------------------------------------------------

          ESP = {
            size = "512M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" "nosuid" "nodev" "noexec" "umask=0077" ];
            };
          };

          # ------------------------------------------------------------------------------------------------
          # Root
          # ------------------------------------------------------------------------------------------------

          luks = {
            size = "100%";

            content = {
              type = "luks";
              name = "crypted";

              content = {
                type = "btrfs";
                subvolumes = {

                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "defaults" "noatime" "nodev" "nosuid" "noexec" ];
                  };

                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "subvol=nix" "noatime" ];
                  };

                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" "subvol=persist" "noatime" "nodev" "nosuid" "noexec" ];
                  };
                };
              };
            };
          };
        };
      };
    };

    # =================================================================================
    # Backup 
    # =================================================================================

    nixos2 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-512GB_SSD_MQ02W52300963";

      content = {
        type = "gpt";

        partitions.backup = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "xfs";
            mountpoint = "/backup";
            mountOptions = [ "noatime" "nofail" "nodev" "nosuid" ];
          };
        };
      };
    };
  };
}
