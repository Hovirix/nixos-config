{ domain, config, ... }: {

  # =================================================================================
  # Traefik
  # =================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.opencloud.loadBalancer.servers = [{
      url = "http://${config.containers.opencloud.localAddress}:9200";
    }];

    routers.opencloud = {
      rule = "Host(`cloud.${domain}`)";
      service = "opencloud";
      entryPoints = [ "websecure" ];
      #   middlewares = [ "authelia" ];
    };
  };

  # =================================================================================
  # Container Config
  # =================================================================================

  containers.opencloud = {

    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.10.100";
    localAddress = "10.10.10.101";

    config = {

      # ===================================================
      # Firewall
      # ===================================================

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 9200 9000 ];
      };

      # ===================================================
      # Opencloud configuration
      # ===================================================

      services.opencloud = {
        enable = true;
        port = 9200;
        url = "https://cloud.${domain}";
        address = config.containers.opencloud.localAddress;

        environment = {
          OC_LOG_LEVEL = "info";
          OC_LOG_COLOR = "true";
          OC_LOG_PRETTY = "true";

          PROXY_TLS = "false";
          OC_INSECURE = "true";
          IDM_ADMIN_PASSWORD = "admin";
        };
      };
    };
  };
}
