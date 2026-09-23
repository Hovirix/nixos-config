{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    imv
    mpv
    bluetui
    impala
    wezterm
    zathura
    ungoogled-chromium
    appflowy
    freetube
    stirling-pdf-desktop
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
