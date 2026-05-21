{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nixpkgs";
    };

    neix = {
      url = "github:Hovirix/neix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          modules = [
            inputs.disko.nixosModules.disko
            inputs.agenix.nixosModules.default

            ./system/disko.nix
            ./system/hardware-configuration.nix

            # core
            ./modules/core/boot.nix
            ./modules/core/network.nix
            ./modules/core/nix.nix
            ./modules/core/time.nix
            ./modules/core/users.nix

            # hardware
            # ./modules/hardware/alsa.nix
            ./modules/hardware/kernel.nix
            ./modules/hardware/bluetooth.nix
            ./modules/hardware/graphics.nix
            ./modules/hardware/tlp.nix
            ./modules/hardware/virtualisation.nix

            # desktop
            # ./modules/desktop/hyprland.nix
            ./modules/desktop/sway.nix
            ./modules/desktop/apps.nix
            ./modules/desktop/pipewire.nix
            ./modules/desktop/font.nix
            # ./modules/desktop/xdg.nix
            ./modules/desktop/flatpak.nix

            # dev
            # ./modules/dev/adb.nix
            ./modules/dev/containers.nix
            ./modules/dev/nh.nix
            ./modules/dev/packages.nix
            ./modules/dev/shell.nix
            ./modules/dev/yubikey.nix

            # services
            ./modules/services/dbus.nix
            ./modules/services/fstrim.nix
            ./modules/services/getty.nix
            ./modules/services/wireguard.nix
          ];

          specialArgs = {
            inherit inputs;
            username = "nixos";
            hostname = "laptop";
          };
        };
      };
    };
}
