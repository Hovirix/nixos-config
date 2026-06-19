{ inputs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    # allowBroken = true;
  };

  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      show-trace = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      download-buffer-size = 524288000;
      experimental-features = [
        "ca-derivations"
        "fetch-tree"
        "flakes"
        "nix-command"
        "pipe-operators"
      ];
      warn-dirty = false;
    };
  };
}
