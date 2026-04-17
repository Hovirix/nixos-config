{ pkgs, ... }:
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
    imv
    mpv
    # Rstudio
    wezterm
    zathura
  ];
}
