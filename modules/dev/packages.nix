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
    rtk
    w3m
    yazi
    btop
    herdr
    helix
    delta
    zoxide
    lazygit
    gh-dash
    ripgrep
    chezmoi
    starship
    trash-cli
    fastfetch
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode
  ];

  programs = {
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    nix-ld.enable = true;
  };
}
