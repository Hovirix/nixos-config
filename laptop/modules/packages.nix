{ inputs, username, pkgs, ... }:
with pkgs;
let
  Rstudio = rstudioWrapper.override {
    packages = with rPackages; [
      languageserver
      ggplot2
      httpgd
      styler
      dplyr
      rlang
      lintr
      BSDA
    ];
  };
in
{
  environment.systemPackages = with pkgs; [

    # Desktop 
    sway
    swaybg
    swayidle
    swaylock
    i3status
    autotiling-rs
    bibata-cursors
    papirus-icon-theme

    # System utilities
    mako
    grim
    slurp
    fuzzel
    impala
    bluetui
    wiremix
    wlsunset
    libnotify
    xdg-utils
    wf-recorder
    wl-clipboard
    brightnessctl
    xdg-desktop-portal-termfilechooser

    # GUI Applications
    imv
    mpv
    wezterm
    Rstudio
    zathura
    appflowy
    freetube
    librewolf
  ];

  users.users.${username}.packages = with pkgs; [

    # Shell / CLI
    gh
    git
    age
    bat
    eza
    fzf
    tmux
    yazi
    btop
    helix
    delta
    zoxide
    direnv
    lazygit
    gh-dash
    ripgrep
    chezmoi
    starship
    opencode
    trash-cli
    fastfetch
    inputs.neix.packages.${pkgs.system}.default
  ];
}
