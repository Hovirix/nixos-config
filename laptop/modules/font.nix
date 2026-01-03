{ pkgs, ... }:
{
  font.packages = with pkgs; [
    hack-font
    dejavu_fonts
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
  ];
}
