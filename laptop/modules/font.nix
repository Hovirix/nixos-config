{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
  ];
}
