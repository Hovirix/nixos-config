{ pkgs, ... }:
with pkgs;
let
  Rstudio = rstudioWrapper.override {
    packages = with rPackages; [
      haven
      dplyr
      fixest
      sandwich
      lmtest
      marginaleffects
      modelsummary
      car
      boot
      ggplot2
      kableExtra
      tibble
      stringr

      # optional dev tools (from your example)
      languageserver
      styler
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    imv
    mpv
    Rstudio
    wezterm
    zathura
  ];
}
