{ username, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraSetFlags = [
      "--operator=${username}"
      "--accept-routes"
    ];
  };
}
