{ inputs, domain, config, ... }: {

  # =================================================================================
  # Traefik
  # =================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.nextcloud.loadbalancer.servers = [{
      url = "http://${config.containers.nextcloud.localAddress}";
    }];

    routers.nextcloud = {
      rule = "Host(`cloud.${domain}`)";
      service = "nextcloud";
      entrypoints = [ "websecure" ];
      middlewares = [ "authelia" ];
    };
  };

  # =================================================================================
  # Container Config
  # =================================================================================

  containers.nextcloud = {
    
    autoStart = true;
    bindMounts."/persist/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;

    privateNetwork = true;
    hostAddress = "10.10.10.6";
    localAddress = "10.10.10.7";

    config = { config, pkgs, ... }: {

      # ===================================================
      # Secrets
      # ===================================================

      imports = [ inputs.agenix.nixosModules.default ];

      age =
        let
          secretFile = name: {
            mode = "440";
            owner = "nextcloud";
            group = "nextcloud";
            file = ../secrets/${name}.age;
          };
        in
        {
          identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
          secrets = {
            nextcloud_adminpassFile = secretFile "nextcloud_adminpassFile";
            nextcloud_client_secret = secretFile "nextcloud_client_secret";
          };
        };

      # ===================================================
      # Firewall
      # ===================================================

      networking = {
        enableIPv6 = false;
        firewall.allowedTCPPorts = [ 80 443 ];
      };

      # ===================================================
      # Nextcloud configuration
      # ===================================================

      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud32;

        extraAppsEnable = true;
        extraApps = {
          inherit
            (config.services.nextcloud.package.packages.apps)
            contacts
            ;
          oidc_login = pkgs.fetchNextcloudApp {
            license = "agpl3Plus";
            sha256 = "sha256-RLYquOE83xquzv+s38bahOixQ+y4UI6OxP9HfO26faI=";
            url = "https://github.com/pulsejet/nextcloud-oidc-login/releases/download/v3.2.2/oidc_login.tar.gz";
          };
        };

        secretFile = config.age.secrets.nextcloud_client_secret.path;

        https = true;
        hostName = "localhost";

        configureRedis = true;
        database.createLocally = true;

        maxUploadSize = "10G";
        phpOptions."opcache.interned_strings_buffer" = "24";

        config = {
          dbtype = "pgsql";
          adminuser = "admin";
          adminpassFile = config.age.secrets.nextcloud_adminpassFile.path;
        };

        settings = {
          log_type = "file";
          maintenance_window_start = 2;
          trusted_proxies = [ "127.0.0.1" ];
          trusted_domains = [ "cloud.${domain}" ];

          defaultapp = "files";
          knowledgebaseenabled = false;

          lost_password_link = "disabled";
          allow_user_to_change_display_name = false;

          oidc_login_auto_redirect = true;
          oidc_login_button_text = "Log in with Authelia";

          oidc_login_client_id = "nextcloud";
          oidc_login_default_group = "oidc";
          oidc_login_code_challenge_method = "S256";

          oidc_login_disable_registration = false;
          oidc_login_end_session_redirect = true;
          oidc_login_hide_password_form = false;

          oidc_login_min_time_between_jwks_requests = 20;
          oidc_login_password_authentication = false;
          oidc_login_proxy_ldap = false;
          oidc_login_provider_url = "https://auth.${domain}";
          oidc_login_public_key_caching_time = 86400;
          oidc_login_redir_fallback = false;
          oidc_login_scope = "openid profile email groups";
          oidc_login_tls_verify = true;
          oidc_login_update_avatar = false;
          oidc_login_use_external_storage = false;
          oidc_login_use_id_token = true;
          oidc_login_webdav_enabled = false;
          oidc_login_well_known_caching_time = 86400;

          oidc_login_attributes = {
            groups = "groups";
            id = "preferred_username";
            mail = "email";
            name = "name";
          };

          user_oidc = {
            single_logout = false;
            auto_provision = true;
            soft_auto_provision = true;
          };

          oidc_create_groups = false;
        };
      };
    };
  };
}





























