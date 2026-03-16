{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    neix = {
      url = "github:Hovirix/neix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... } @inputs: {

    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {

        modules = [
          inputs.disko.nixosModules.disko
          ./modules/nh.nix
          ./modules/tlp.nix
          ./modules/nix.nix
          ./modules/zsh.nix
          # ./modules/adb.nix
          ./modules/font.nix
          # ./modules/alsa.nix
          ./modules/boot.nix
          ./modules/time.nix
          ./modules/users.nix
          ./modules/disko.nix
          ./modules/fstrim.nix
          ./modules/kernel.nix
          ./modules/network.nix
          ./modules/packages.nix
          ./modules/graphics.nix
          ./modules/pipewire.nix
          ./modules/bluetooth.nix
          # ./modules/tailscale.nix
          ./modules/configuration.nix
          ./modules/virtualisation.nix
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
