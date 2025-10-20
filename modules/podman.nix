{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.podman-compose ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
    dockerSocket.enable = true;
  };
}
