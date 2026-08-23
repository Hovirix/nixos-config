{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      autotiling-rs
      bibata-cursors
      brightnessctl
      fuzzel
      grim
      i3status
      libnotify
      mako
      papirus-icon-theme
      swaybg
      swayidle
      swaylock
      slurp
      wf-recorder
      wl-clipboard
      wlsunset
    ];
  };

  systemd.user.settings.Manager = {
    DefaultEnvironment = [
      "PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    ];
  };

  security.pam.services.swaylock = { };
}
