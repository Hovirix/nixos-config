{ pkgs, ... }:
{
  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-manager
      yubikey-personalization
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
