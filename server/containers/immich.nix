{ config, domain, ... }: {

  # =================================================================================
  # Traefik
  # =================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.immich.loadBalancer.servers = [{
      url = "http://${config.containers.immich.localAddress}:${toString config.containers.immich.config.services.immich.port}";
    }];

    routers.immich = {
      rule = "Host(`photos.${domain}`)";
      service = "immich";
      entrypoints = [ "websecure" ];
      middlewares = [ "authelia" ];
    };
  };

  # =================================================================================
  # Container Config
  # =================================================================================

  containers.immich = {

    autoStart = true;
    privateUsers = "pick";

    privateNetwork = true;
    hostAddress = "10.10.10.4";
    localAddress = "10.10.10.5";

    config = {

      # ------------------------------------------------------------------
      # Firewall
      # ------------------------------------------------------------------

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 2283 ];
      };

      # ------------------------------------------------------------------
      # Immich
      # ------------------------------------------------------------------

      services.immich = {
        enable = true;
        port = 2283;
        host = config.containers.immich.localAddress;
      };
    };
  };
}
