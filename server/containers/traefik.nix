{ inputs, ... }:
{
  containers.traefik = {
    autoStart = true;
    privateNetwork = false;
    bindMounts."/persist/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;

    config = { config, ... }: {

      # ============================================================================
      # Secrets
      # ============================================================================

      imports = [ inputs.agenix.nixosModules.default ];

      age = {
        identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
        secrets.cloudflare_dns_token = {
          mode = "440";
          owner = "traefik";
          group = "traefik";
          file = ../secrets/cloudflare_dns_token.age;
        };
      };

      # ============================================================================
      # Firewall
      # ============================================================================

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 80 443 ];
      };

      # ============================================================================
      # Traefik configuration
      # ============================================================================

      services.traefik = {
        enable = true;
        environmentFiles = [ config.age.secrets.cloudflare_dns_token.path ];

        staticConfigOptions = {

          # ------------------------------------------------------------------------
          # Logs
          # ------------------------------------------------------------------------

          log = {
            level = "INFO";
            format = "json";
          };

          # ------------------------------------------------------------------------
          # API
          # ------------------------------------------------------------------------

          api = {
            debug = false;
            insecure = false;
            dashboard = false;
          };

          # ------------------------------------------------------------------------
          # TLS
          # ------------------------------------------------------------------------

          certificatesResolvers.letsencrypt.acme = {

            email = "test.rearrange726@passfwd.com";
            storage = "${config.services.traefik.dataDir}/acme.json";

            dnsChallenge = {
              provider = "cloudflare";
              resolvers = [ "1.1.1.1:53" "8.8.8.8:53" ];
            };
          };

          tls.options = {

            default = {
              sniStrict = true;
              minVersion = "VersionTLS13";
            };

            intermediate = {
              minVersion = "VersionTLS12";
              cipherSuites = [
                "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
                "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
                "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
                "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305"
                "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
                "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
              ];
            };
          };

          # ------------------------------------------------------------------------
          # Entrypoints
          # ------------------------------------------------------------------------

          entryPoints = {

            web = {
              address = ":80";
              http.redirections.entrypoint = { to = "websecure"; scheme = "https"; };
            };

            websecure = {
              address = ":443";
              asDefault = true;
              http.tls.certResolver = "letsencrypt";
            };
          };
        };
      };
    };
  };
}
