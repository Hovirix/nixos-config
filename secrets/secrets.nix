let
  PublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjCf1PpvoMshFkoyjFOYUJ6/pLexwEFqr29COJawkoB"
  ];
in
{
  "wg_config.age" = {
    armor = true;
    publicKeys = PublicKeys;
  };

  "restic_password.age" = {
    armor = true;
    publicKeys = PublicKeys;
  };

  "restic_ssh_key.age" = {
    armor = true;
    publicKeys = PublicKeys;
  };
}
