{ username, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nixos-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 3d --keep 3";
    };
  };
}
