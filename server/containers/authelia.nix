{ inputs, domain, config, ... }: {

  # ===========================================================================================
  # Traefik
  # ===========================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.authelia.loadBalancer.servers = [{
      url = "http://${config.containers.authelia.localAddress}:9091";
    }];

    middlewares.authelia.forwardAuth = {
      address = "http://${config.containers.authelia.localAddress}:9091/api/authz/forward-auth";
      trustForwardHeader = true;
      authResponseHeaders = [
        "Remote-User"
        "Remote-Name"
        "Remote-Email"
        "Remote-Groups"
      ];
    };

    routers.authelia = {
      rule = "Host(`auth.${domain}`)";
      service = "authelia";
      entrypoints = [ "websecure" ];
    };
  };

  # ===========================================================================================
  # Container Config
  # ===========================================================================================

  containers.authelia = {
    autoStart = true;
    # ephemeral = true;
    bindMounts."/persist/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;

    privateNetwork = true;
    hostAddress = "10.10.10.8";
    localAddress = "10.10.10.9";

    config = { config, ... }: {

      # ==================================================================================
      # Secrets
      # ==================================================================================

      imports = [ inputs.agenix.nixosModules.default ];

      age =
        let
          secretFile = name: {
            mode = "440";
            owner = "authelia-main";
            group = "authelia-main";
            file = ../secrets/${name}.age;
          };
        in
        {
          identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
          secrets = {
            authelia_jwtSecret = secretFile "authelia_jwtSecretFile";
            authelia_sessionSecret = secretFile "authelia_sessionSecretFile";
            authelia_storageEncryptionKey = secretFile "authelia_storageEncryptionKeyFile";
            authelia_oidcIssuerPrivateKey = secretFile "authelia_oidcIssuerPrivateKeyFile";
            authelia_oidcHmacSecret = secretFile "authelia_oidcHmacSecretFile";
            authelia_users_database = secretFile "authelia_users_database";
          };
        };

      # ==================================================================================
      # Firewall
      # ==================================================================================

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 80 443 9091 ];
      };

      # ==================================================================================
      # User Database
      # ==================================================================================

      environment.etc."authelia/users_database.yml" = {
        mode = "0400";
        user = "authelia-main";
        group = "authelia-main";
        source = "${config.age.secrets.authelia_users_database.path}";
      };

      # ==================================================================================
      # Authelia configuration
      # ==================================================================================

      services.authelia.instances.main = {
        enable = true;

        secrets = {
          jwtSecretFile = "${config.age.secrets.authelia_jwtSecret.path}";
          sessionSecretFile = "${config.age.secrets.authelia_sessionSecret.path}";
          storageEncryptionKeyFile = "${config.age.secrets.authelia_storageEncryptionKey.path}";
          oidcIssuerPrivateKeyFile = "${config.age.secrets.authelia_oidcIssuerPrivateKey.path}";
          oidcHmacSecretFile = "${config.age.secrets.authelia_oidcHmacSecret.path}";
        };

        settings = {

          server.endpoints.authz.forward-auth.implementation = "ForwardAuth";

          # ----------------------------------------------------
          # Logs
          # ----------------------------------------------------

          log = {
            level = "info";
            format = "json";
          };

          # ----------------------------------------------------
          # First Factor
          # ----------------------------------------------------

          authentication_backend = {

            password_reset.disable = true;
            password_change.disable = true;

            file = {
              search.email = true;
              path = "/etc/authelia/users_database.yml";
            };
          };

          # ----------------------------------------------------
          # Second factor
          # ----------------------------------------------------

          totp.disable = true;
          duo_api.disable = true;
          webauthn.disable = true;

          # ----------------------------------------------------
          # Security
          # ----------------------------------------------------

          access_control.rules = [
            { domain = [ "auth.${domain}" "cloud.${domain}" "photos.${domain}" ]; policy = "bypass"; }
            { domain = "*." + domain; policy = "one_factor"; }
          ];

          regulation = {
            max_retries = 3;
            find_time = "5m";
            ban_time = "15m";
          };

          # ----------------------------------------------------
          # Session
          # ----------------------------------------------------

          session.cookies = [{
            inherit domain;
            authelia_url = "https://auth.${domain}";
          }];

          # ----------------------------------------------------
          # Storage
          # ----------------------------------------------------

          storage.local.path = "/var/lib/authelia-main/db.sqlite3";

          # ----------------------------------------------------
          # Notifications
          # ----------------------------------------------------

          notifier = {
            disable_startup_check = true;
            # smtp = { };
            filesystem.filename = "/var/lib/authelia-main/notification.txt";
          };

          # ----------------------------------------------------
          # OICD
          # ----------------------------------------------------

          identity_providers.oidc = {

            claims_policies = { nextcloud_policy.id_token = [ "groups" "email" "email_verified" "alt_emails" "preferred_username" "name" ]; };

            clients = [
              {
                authorization_policy = "one_factor";
                client_id = "immich";
                client_secret = "$pbkdf2-sha512$310000$pBNyorMAWvGmHIQWfe3YvA$156ErhaEVFjYP8p1RK9Bf4agxEfp9vPZsYD6xQP0HmxOqOR8uETsIOwpGoXh.yRmsciLVC3paGj2i0nYad4M9A";
                token_endpoint_auth_method = "client_secret_post";

                redirect_uris = [
                  "app.immich:///oauth-callback"
                  "https://photos.${domain}/auth/login"
                  "https://photos.${domain}/user-settings"
                ];
              }
              {
                authorization_policy = "one_factor";
                client_id = "nextcloud";
                client_secret = "$pbkdf2-sha512$310000$i1EeUlPciQyUgLK.MhrVTQ$AAG3qDYllJEEqV2wO.VCTrdafkw24u/WBw5qfJJjGrF.RAoqDIRmS8r2Sbg.0Rvitj5Yb32pT2tcc4JXE6clFQ";
                token_endpoint_auth_method = "client_secret_basic";

                require_pkce = true;
                pkce_challenge_method = "S256";

                claims_policy = "nextcloud_policy";
                redirect_uris = [ "https://cloud.${domain}/apps/oidc_login/oidc" ];
              }
            ];
          };
        };
      };
    };
  };
}

