{ config, ... }:
{
  age = {
    identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets.restic_password = {
      mode = "440";
      owner = "root";
      group = "root";
      file = ../secrets/restic_password.age;
    };
  };

  services.restic.backups.backup = {

    initialize = true;
    passwordFile = config.age.secrets.restic_password.path;

    repository = "/backup";
    extraBackupArgs = [ "--exclude-caches" "--compression=max" ];

    paths = [
      "/persist/etc/ssh"
      "/persist/var/lib/nixos-containers/immich/var/lib/immich"
      "/persist/var/lib/nixos-containers/immich/var/lib/postgresql"
      "/persist/var/lib/nixos-containers/opencloud/var/lib/opencloud"
      "/persist/var/lib/nixos-containers/vaultwarden/var/lib/vaultwarden"
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 2"
      "--keep-monthly 1"
      "--keep-yearly 0"
    ];

    timerConfig = {
      Persistent = true;
      OnCalendar = "daily";
      RandomizedDelaySec = 3600;
    };
  };
}
