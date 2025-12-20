{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... } @inputs: {

    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {

      specialArgs = {
        inherit inputs;
        username = "nixos";
        hostname = "homelab";
        domain = "nemnix.site";
      };

      modules = [
        ./modules/nix.nix
        ./modules/git.nix
        ./modules/bash.nix
        ./modules/users.nix
        ./modules/disko.nix
        ./modules/kernel.nix
        ./modules/fstrim.nix
        ./modules/restic.nix
        ./modules/podman.nix
        ./modules/openssh.nix
        ./modules/network.nix
        ./modules/systemd.nix
        ./modules/packages.nix
        ./modules/graphics.nix
        ./modules/bootloader.nix
        ./modules/auto-upgrade.nix
        ./modules/impermanence.nix
        ./modules/hardware-configuration.nix

        ./containers/immich.nix
        ./containers/adguard.nix
        ./containers/traefik.nix
        ./containers/authelia.nix
        # ./containers/nextcloud.nix
        ./containers/vaultwarden.nix
        ./containers/cloudflared.nix
        ./containers/opencloud.nix
        # ./containers/linkwarden.nix

        inputs.disko.nixosModules.disko
        inputs.agenix.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.impermanence.nixosModules.impermanence
      ];
    };
  };
}
