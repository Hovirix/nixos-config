{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    packages = [
      "io.appflowy.AppFlowy"
      "io.freetubeapp.FreeTube"
      "io.gitlab.librewolf-community"
      "org.torproject.torbrowser-launcher"
    ];
  };
}
