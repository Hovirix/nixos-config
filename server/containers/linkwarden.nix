{ config, domain, ... }: {

  # =================================================================================
  # Traefik
  # =================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.linkwarden.loadBalancer.servers = [{
      url = "http://${config.containers.linkwarden.localAddress}:${toString config.containers.linkwarden.config.services.linkwarden.port}";
    }];

    routers.linkwarden = {
      rule = "Host(`photos.${domain}`)";
      service = "linkwarden";
      entrypoints = [ "websecure" ];
      middlewares = [ "authelia" ];
    };
  };

  # =================================================================================
  # Container Config
  # =================================================================================

  containers.linkwarden = {

    autoStart = true;
    privateUsers = "pick";

    privateNetwork = true;
    hostAddress = "10.10.10.18";
    localAddress = "10.10.10.19";

    config = {

      # ------------------------------------------------------------------
      # Firewall
      # ------------------------------------------------------------------

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 3000 ];
      };

      # ------------------------------------------------------------------
      # Linkwarden
      # ------------------------------------------------------------------

      services.linkwarden = {
        enable = true;
        port = 3000;
        host = config.containers.linkwarden.localAddress;
      };
    };
  };
}
