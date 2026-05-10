{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      autotiling-rs
      bibata-cursors
      bluetui
      brightnessctl
      fuzzel
      grim
      i3status
      impala
      libnotify
      mako
      nwg-displays
      papirus-icon-theme
      swaybg
      swayidle
      swaylock
      slurp
      wf-recorder
      wiremix
      wl-clipboard
      wlsunset
    ];
  };

  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';

  security.pam.services.swaylock = { };
}
