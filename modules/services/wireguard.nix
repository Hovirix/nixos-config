{ config, username, ... }:
{
  age = {
    identityPaths = [ "/home/${username}/.ssh/id_ed25519" ];
    secrets.wg_config = {
      file = ../../secrets/wg_config.age;
      owner = "root";
      group = "root";
      mode = "600";
    };
  };

  networking = {
    firewall.checkReversePath = "loose";
    wg-quick.interfaces.wg0 = {
      autostart = false;
      configFile = config.age.secrets.wg_config.path;
    };
  };
}
