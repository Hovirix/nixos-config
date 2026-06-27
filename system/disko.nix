{
  disko.devices = {
    disk.nixos = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT1000P3SSD8_2321E6DBFB5A";

      content = {
        type = "gpt";

        partitions = {
          boot = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "umask=0077"
                "nodev"
                "nosuid"
                "noexec"
              ];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              extraOpenArgs = [ "--allow-discards" ];
              content = {
                type = "lvm_pv";
                vg = "system";
              };
            };
          };
        };
      };
    };

    lvm_vg.system = {
      type = "lvm_vg";
      lvs = {

        nix = {
          size = "300G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
            mountOptions = [
              "defaults"
              "noatime"
              "lazytime"
              "commit=600"
              "nodev"
            ];
          };
        };

        home = {
          size = "600G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/home";
            mountOptions = [
              "defaults"
              "noatime"
              "lazytime"
              "commit=600"
              "nodev"
              "nosuid"
            ];
          };
        };

        persist = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/persist";
            mountOptions = [
              "defaults"
              "noatime"
              "lazytime"
              "commit=600"
              "nodev"
              "nosuid"
            ];
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=4G"
        "mode=755"
        "nodev"
        "nosuid"
      ];
    };
  };
}
