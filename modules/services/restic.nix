{ config, username, ... }:
let
  repositoryHost = "truenas.home.hovirix.dev";
  repositoryPath = "/mnt/tank/laptop_backups";
  repositoryUser = "backup-laptop";
in
{
  age.secrets = {
    restic_password = {
      file = ../../secrets/restic_password.age;
      mode = "0400";
      owner = username;
    };

    restic_ssh_key = {
      file = ../../secrets/restic_ssh_key.age;
      mode = "0400";
      owner = username;
    };
  };

  services.restic.backups.laptop = {
    user = username;
    initialize = true;
    repository = "sftp:${repositoryUser}@${repositoryHost}:${repositoryPath}";
    passwordFile = config.age.secrets.restic_password.path;

    paths = [
      "/home/${username}/Documents"
    ];

    extraOptions = [
      "sftp.command='ssh -i ${config.age.secrets.restic_ssh_key.path} -o IdentitiesOnly=yes ${repositoryUser}@${repositoryHost} -s sftp'"
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
