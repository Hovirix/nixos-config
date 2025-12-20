{ username, ... }:
{
  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjCf1PpvoMshFkoyjFOYUJ6/pLexwEFqr29COJawkoB"
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    allowSFTP = true;

    settings = {
      LogLevel = "VERBOSE";

      PermitTunnel = false;
      PermitRootLogin = "no";
      PermitEmptyPasswords = false;
      PasswordAuthentication = false;
      AuthenticationMethods = "publickey";
      KbdInteractiveAuthentication = false;

      MaxSessions = 2;
      MaxAuthTries = 3;
      clientAliveCountMax = 1;
      clientAliveInterval = 60;

      TCPKeepAlive = false;
      DisableForwarding = true;

      KexAlgorithms = [
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
        "curve25519-sha256@libssh.org"
      ];

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes256-ctr"
      ];

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-512"
      ];
    };
  };
}

