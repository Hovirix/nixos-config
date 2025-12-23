{ username, pkgs, ... }:
# with pkgs;
# let
#   Rstudio = rstudioWrapper.override {
#     packages = with rPackages; [
#       languageserver
#       ggplot2
#       httpgd
#       styler
#       dplyr
#       rlang
#       lintr
#       BSDA
#     ];
#   };
# in
{
  environment.systemPackages = with pkgs; [

    # Desktop
    sway
    swayidle
    swaylock
    i3status
    autotiling-rs

    # utilities
    mako
    grim
    slurp
    fuzzel
    impala
    bluetui
    wlsunset
    libnotify
    wf-recorder
    wl-clipboard
    brightnessctl

    # Apps
    imv
    mpv
    foot
    tmux
    yazi
    btop
    helix
    lazygit
    zathura
    appflowy
    freetube
    ungoogled-chromium

    yaziPlugins.compress
    yaziPlugins.recycle-bin
    yaziPlugins.full-border

    # CLI tools
    gh
    zsh
    bat
    eza
    fzf
    git
    stow
    zoxide
    starship
    trash-cli
    fastfetch
    github-copilot-cli
  ];

  users.users.${username}.packages = with pkgs; [

    # Nix
    nil
    nixpkgs-fmt

    # Python
    uv
    ruff
    pyright

    # Bash
    shfmt
    bash-language-server

    # JavaScript
    pnpm
    nodejs

    # YAML
    yamlfix
    yaml-language-server

    # Ansible
    ansible
    ansible-lint

    # Containers
    dockerfmt
    podman-tui
    docker-language-server

    # Terraform
    terraform
    terraform-ls
  ];
}
