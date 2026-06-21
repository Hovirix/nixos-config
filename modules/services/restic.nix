{ config, username, ... }:
let
  repositoryHost = "truenas.home.hovirix.dev";
  repositoryPath = "/mnt/tank/laptop_backups";
  repositoryUser = "backup-laptop";
in
{
  sops = {
    secrets = {
      "restic/password" = {
        mode = "0400";
        owner = username;
      };

      "restic/ssh_key" = {
        mode = "0400";
        owner = username;
      };
    };
  };

  services.restic.backups.laptop = {
    user = username;
    initialize = true;
    repository = "sftp:${repositoryUser}@${repositoryHost}:${repositoryPath}";
    passwordFile = config.sops.secrets."restic/password".path;

    paths = [
      "/home/${username}/Documents"
    ];

    extraOptions = [
      "sftp.command='ssh -i ${
        config.sops.secrets."restic/ssh_key".path
      } -o IdentitiesOnly=yes ${repositoryUser}@${repositoryHost} -s sftp'"
    ];

    extraBackupArgs = [
      "--skip-if-unchanged"
    ];

    pruneOpts = [
      "--keep-daily=14"
      "--keep-weekly=8"
      "--keep-monthly=12"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
