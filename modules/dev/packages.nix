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
    zk
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
    # direnv
    lazygit
    gh-dash
    ripgrep
    chezmoi
    starship
    opencode
    trash-cli
    fastfetch
    inputs.neix.packages.${pkgs.system}.default
    (pass.withExtensions (exts: [
      exts.pass-otp
      exts.pass-import
    ]))
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
