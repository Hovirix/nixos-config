{ pkgs, ... }:
{
  programs.mango = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    bibata-cursors
    brightnessctl
    foot
    grim
    jq # For IPC
    libnotify
    papirus-icon-theme
    quickshell
    slurp
    swaybg
    swayidle
    swaylock
    wf-recorder
    wl-clipboard
    wlr-randr
    wlsunset
  ];

  security.pam.services.swaylock = { };
}
