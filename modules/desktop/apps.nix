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
    freetube
    thunderbird
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
