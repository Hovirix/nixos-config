{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    overrides = {
      global.Context = {
        sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];
        filesystems = [ "!home" ];
        devices = [ "!all" ];
      };
    };

    packages = [
      "io.appflowy.AppFlowy"
      "io.freetubeapp.FreeTube"
      "io.gitlab.librewolf-community"
      "io.github.ungoogled_software.ungoogled_chromium"
      "org.torproject.torbrowser-launcher"
    ];
  };
}
