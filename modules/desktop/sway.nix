{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    xwayland.enable = false;
    extraPackages = with pkgs; [
      swaybg
      swayidle
      swaylock
      i3status
      autotiling-rs
      bibata-cursors
      papirus-icon-theme
      mako
      grim
      slurp
      fuzzel
      impala
      bluetui
      wiremix
      wlsunset
      libnotify
      wf-recorder
      brightnessctl
      xdg-utils
      wl-clipboard
    ];
  };

  security.pam.services.swaylock = { };
}
