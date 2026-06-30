{
  config,
  pkgs,
  username,
  ...
}:
let
  backupUser = "laptop";
  backupHost = "truenas.home.hovirix.dev";
  backupPath = "/mnt/tank/backups/${backupUser}";

  resticPassword = config.sops.secrets."restic/password".path;
  resticSshKey = config.sops.secrets."restic/ssh".path;
in
{
  sops.secrets = {
    "restic/password" = {
      owner = "root";
      mode = "0400";
    };

    "restic/ssh" = {
      owner = "root";
      mode = "0400";
    };
  };

  environment.systemPackages = [ pkgs.restic ];

  services.restic.backups.main = {
    user = "root";
    initialize = true;

    repository = "sftp:${backupUser}@${backupHost}:${backupPath}";
    passwordFile = resticPassword;

    paths = [
      "/etc/ssh/id_ed25519"
      "/etc/ssh/id_ed25519.pub"
      "/home/${username}/.gnupg"
      "/home/${username}/.password-store"
      "/home/${username}/.ssh"
      "/home/${username}/Documents"
      "/home/${username}/Projects"
      "/var/lib/iwd"
      "/var/lib/sbctl"
    ];

    extraOptions = [
      "sftp.command='ssh -i ${resticSshKey} -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new ${backupUser}@${backupHost} -s sftp'"
    ];

    extraBackupArgs = [
      "--skip-if-unchanged"
      "--one-file-system"
    ];

    pruneOpts = [
      "--keep-daily=14"
      "--keep-weekly=8"
      "--keep-monthly=12"
    ];

    checkOpts = [
      "--read-data-subset=5%"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
