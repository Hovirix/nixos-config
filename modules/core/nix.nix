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
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
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
