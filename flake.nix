{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    llm-agents.url = "github:numtide/llm-agents.nix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
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
            inputs.sops-nix.nixosModules.sops

            ./system/disko.nix
            ./system/hardware.nix

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
            ./modules/desktop/mango.nix
            ./modules/desktop/apps.nix
            ./modules/desktop/pipewire.nix
            ./modules/desktop/font.nix
            ./modules/desktop/xdg.nix

            # dev
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
            ./modules/services/upower.nix
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
