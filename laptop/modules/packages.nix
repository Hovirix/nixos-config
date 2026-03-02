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

    # GUI Applications
    imv
    mpv
    wezterm
    Rstudio
    zathura
    # appflowy
    freetube
    librewolf
    inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.appflowy
  ];

  users.users.${username}.packages = with pkgs; [

    # Shell / CLI
    gh
    git
    bat
    eza
    fzf
    tmux
    yazi
    btop
    stow
    helix
    zoxide
    lazygit
    ripgrep
    starship
    opencode
    trash-cli
    fastfetch

    # Nix
    nil
    nixpkgs-fmt
    inputs.neix.packages.${pkgs.system}.default

    # Bash
    shfmt
    bash-language-server
  ];
}
