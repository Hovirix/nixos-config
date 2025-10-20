{ domain, config, ... }: {

  # =================================================================================
  # Traefik
  # =================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.vaultwarden.loadBalancer.servers = [{
      url = "http://${config.containers.vaultwarden.localAddress}:${toString config.containers.vaultwarden.config.services.vaultwarden.config.ROCKET_PORT}";
    }];

    routers.vaultwarden = {
      rule = "Host(`vault.${domain}`)";
      service = "vaultwarden";
      entrypoints = [ "websecure" ];
      middlewares = [ ];
    };
  };

  # =================================================================================
  # Container Config
  # =================================================================================

  containers.vaultwarden = {
    autoStart = true;
    privateUsers = "pick";

    privateNetwork = true;
    hostAddress = "10.10.10.2";
    localAddress = "10.10.10.3";

    config = _: {

      # ------------------------------------------------------------------
      # Firewall
      # ------------------------------------------------------------------

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 80 443 8000 ];
      };

      # ------------------------------------------------------------------
      # Vaultwarden
      # ------------------------------------------------------------------

      services.vaultwarden = {
        enable = true;
        config = {

          # ADMIN_TOKEN = "admin";
          # SIGNUPS_ALLOWED = true;
          DOMAIN = "https://vault.${domain}";

          USE_SYSLOG = true;
          ROCKET_LOG = "critical";

          ROCKET_PORT = 8000;
          ROCKET_ADDRESS = config.containers.vaultwarden.localAddress;
        };
      };
    };
  };
}
