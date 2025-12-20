{ username, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nixos-config/laptop";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 3d --keep 3";
    };
  };
}
