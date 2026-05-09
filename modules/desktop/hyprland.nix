{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # xwayland.enable = false;
  };

  environment.systemPackages = with pkgs; [
    bibata-cursors
    bluetui
    brightnessctl
    fuzzel
    grim
    hypridle
    hyprlock
    hyprpaper
    hyprsunset
    impala
    libnotify
    mako
    nwg-displays
    papirus-icon-theme
    polkit_gnome
    slurp
    waybar
    wiremix
    wl-clipboard
  ];
}
