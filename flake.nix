{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neix = {
      url = "github:Hovirix/neix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      apps.${system}.install = {
        type = "app";
        meta.description = "Install the laptop configuration locally with nixos-anywhere";
        program = "${
          pkgs.writeShellApplication {
            name = "install-laptop";
            runtimeInputs = [ inputs.nixos-anywhere.packages.${system}.nixos-anywhere ];
            text = ''
              nixos-anywhere \
                --generate-hardware-config nixos-generate-config ./system/hardware-configuration.nix \
                --flake .#laptop \
                --target-host root@localhost
            '';
          }
        }/bin/install-laptop";
      };

      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          modules = [
            inputs.disko.nixosModules.disko
            inputs.preservation.nixosModules.preservation
            inputs.sops-nix.nixosModules.sops

            ./system/disko.nix
            ./system/hardware-configuration.nix
            ./system/preservation.nix

            # core
            ./modules/core/boot.nix
            ./modules/core/network.nix
            ./modules/core/nix.nix
            ./modules/core/secrets.nix
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
            ./modules/dev/packages.nix
            ./modules/dev/shell.nix
            ./modules/dev/yubikey.nix

            # services
            # ./modules/services/ratbagd.nix
            ./modules/services/dbus.nix
            ./modules/services/fstrim.nix
            ./modules/services/getty.nix
            ./modules/services/restic.nix
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
