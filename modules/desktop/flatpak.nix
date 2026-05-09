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
      "md.obsidian.Obsidian"
      "io.freetubeapp.FreeTube"
      "io.gitlab.librewolf-community"
      "org.torproject.torbrowser-launcher"
    ];
  };
}
