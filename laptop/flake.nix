{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... } @inputs: {

    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {

        modules = [
          inputs.disko.nixosModules.disko
          ./modules/nh.nix
          ./modules/vm.nix
          ./modules/tlp.nix
          ./modules/nix.nix
          # ./modules/adb.nix
          ./modules/boot.nix
          ./modules/time.nix
          ./modules/users.nix
          ./modules/disko.nix
          ./modules/fstrim.nix
          ./modules/kernel.nix
          ./modules/network.nix
          ./modules/graphics.nix
          ./modules/pipewire.nix
          ./modules/bluetooth.nix
          ./modules/home-manager.nix
          ./modules/configuration.nix
          ./modules/hardware-configuration.nix
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
