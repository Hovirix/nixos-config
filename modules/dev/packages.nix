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
    herdr
    helix
    delta
    zoxide
    lazygit
    gh-dash
    ripgrep
    chezmoi
    starship
    fastfetch
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.rtk
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2
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
