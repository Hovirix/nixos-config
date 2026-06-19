{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    imv
    mpv
    wezterm
    zathura
  ];
}
