{ inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
  };

  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      show-trace = true;
      require-sigs = false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      download-buffer-size = 524288000;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
