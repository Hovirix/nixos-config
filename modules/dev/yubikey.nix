{ pkgs, ... }:
{
  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-manager
  ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    yubikey-touch-detector = {
      enable = true;
      libnotify = true;
    };
  };
}
