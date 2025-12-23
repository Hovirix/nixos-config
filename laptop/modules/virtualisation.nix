{ pkgs, username, ... }:
{
  users.users.${username}.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;

  virtualisation = {

    podman = {
      enable = true;
      autoprune.enable = true;
    };

    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";

      qemu = {
        runAsRoot = false;
        swtpm.enable = true;
        package = pkgs.qemu_kvm;
      };
    };
  };
}
