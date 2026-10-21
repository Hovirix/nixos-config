{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [ dnsmasq ];
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      runAsRoot = false;
      swtpm.enable = true;
      package = pkgs.qemu_kvm;
    };
  };
  programs.virt-manager.enable = true;
  users.users.${username}.extraGroups = [
    "kvm"
    "libvirtd"
  ];
}
