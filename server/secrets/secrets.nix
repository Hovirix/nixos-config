let
  PublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjCf1PpvoMshFkoyjFOYUJ6/pLexwEFqr29COJawkoB"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhLtSav5LaQK7/F79Kg+xAZUty68E4sf2gPNUgfu7IP"
  ];
in
{
  "restic_password.age".publicKeys = PublicKeys;

  "cloudflare_dns_token.age".publicKeys = PublicKeys;
  "cloudflare_tunnel_token.age".publicKeys = PublicKeys;

  "nextcloud_client_secret.age".publicKeys = PublicKeys;
  "nextcloud_adminpassFile.age".publicKeys = PublicKeys;

  "authelia_jwtSecretFile.age".publicKeys = PublicKeys;
  "authelia_sessionSecretFile.age".publicKeys = PublicKeys;
  "authelia_storageEncryptionKeyFile.age".publicKeys = PublicKeys;
  "authelia_oidcIssuerPrivateKeyFile.age".publicKeys = PublicKeys;
  "authelia_oidcHmacSecretFile.age".publicKeys = PublicKeys;
  "authelia_users_database.age".publicKeys = PublicKeys;
}
  
