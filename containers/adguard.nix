{ domain, config, ... }: {

  # =================================================================================
  # Traefik
  # =================================================================================

  containers.traefik.config.services.traefik.dynamicConfigOptions.http = {

    services.adguard.loadBalancer.servers = [{
      url = "http://127.0.0.1:${toString config.containers.adguard.config.services.adguardhome.port}";
    }];

    routers.adguard = {
      rule = "Host(`adguard.${domain}`)";
      service = "adguard";
      entrypoints = [ "websecure" ];
      middlewares = [ "authelia" ];
    };
  };

  # =================================================================================
  # Container Config
  # =================================================================================

  containers.adguard = {
    autoStart = true;
    ephemeral = true;
    privateNetwork = false;

    config = {

      services.adguardhome = {
        enable = true;
        mutableSettings = false;

        port = 8080;
        host = "127.0.0.1";

        settings = {

          # ----------------------------------------------------
          # Misc
          # ----------------------------------------------------

          cache_size = 4194304;
          querylog = { enabled = true; interval = "168h"; };
          statistics = { enabled = true; interval = "168h"; };

          # ----------------------------------------------------
          # DNS
          # ----------------------------------------------------

          dns = {
            ratelimit = 0;
            cache_size = 256 * 1024 * 1024;
            cache_optimistic = true;

            enable_dnssec = true;
            upstream_mode = "parallel";
            use_http3_upstreams = true;

            upstream_dns = [
              "tls://dns.quad9.net"
              "quic://dns.adguard-dns.com"
            ];

            bootstrap_dns = [
              # Adguard
              "94.140.14.14"
              "94.140.15.15"
              # Quad9
              "9.9.9.9"
              "149.112.112.112"
            ];
          };

          # ----------------------------------------------------
          # Protection
          # ----------------------------------------------------

          filtering = {
            filtering_enabled = true;
            protection_enabled = true;
            safe_search.enabled = false;
            rewrites = [{ domain = "*.${domain}"; answer = "192.168.1.20"; }];
          };

          filters = map (url: { enabled = true; inherit url; }) [
            "https://badmojr.github.io/1Hosts/Pro/adblock.txt"
            # "https://cdn.jsdelivr.net/gh/badmojr/1Hosts@master/Xtra/adblock.txt"

            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/ultimate.txt"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/spam-tlds.txt"
            "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/native.apple.txt"

            "https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Apple"
            "https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Lists/Tracking"
          ];
        };
      };
    };
  };
}



