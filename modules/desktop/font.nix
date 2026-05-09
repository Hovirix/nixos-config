{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome
    dejavu_fonts
    jetbrains-mono
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
  ];
}
