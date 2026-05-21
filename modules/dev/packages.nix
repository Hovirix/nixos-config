{
  pkgs,
  username,
  inputs,
  ...
}:
{
  users.users.${username}.packages = with pkgs; [
    fd
    gh
    git
    age
    bat
    eza
    fzf
    w3m
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

  programs.direnv = {
    silent = true;
    nix-direnv.enable = true;
  };
}
