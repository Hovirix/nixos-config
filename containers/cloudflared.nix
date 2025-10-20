{ config, pkgs, ... }:
{
  # =======================================================================================
  # Secrets
  # =======================================================================================

  age = {
    identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets.cloudflare_tunnel_token = {
      mode = "440";
      owner = "cloudflared";
      group = "cloudflared";
      file = ../secrets/cloudflare_tunnel_token.age;
    };
  };

  # =======================================================================================
  # User + Group
  # =======================================================================================

  users = {
    users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
    };
    groups.cloudflared = { };
  };

  # =======================================================================================
  # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html
  # https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html#
  # =======================================================================================

  systemd.services.cloudflared-tunnel = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel run --token-file ${config.age.secrets.cloudflare_tunnel_token.path}";
      Restart = "on-failure";
      RestartSec = 5;

      # Paths
      ProcSubset = "pid";
      ProtectProc = "invisible";
      ReadOnlyPaths = [ config.age.secrets.cloudflare_tunnel_token.path ];

      # User/Group Identity
      User = "cloudflared";
      Group = "cloudflared";

      # Capabilities
      AmbientCapabilities = null;
      CapabilityBoundingSet = null;

      # Security
      NoNewPrivileges = true;

      # Process Properties
      UMask = "0077";
      KeyringMode = "private";

      # Sandboxing
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivatePIDs = true;
      PrivateUsers = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;

      # System Call Filtering
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "~@clock"
        "~@cpu-emulation"
        "~@debug"
        "~@module"
        "~@mount"
        "~@obsolete"
        "~@privileged"
        "~@raw-io"
        "~@reboot"
        "~@resources"
        "~@swap"
      ];
    };
  };
}
