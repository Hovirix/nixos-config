{ config, ... }:
{
  age.secrets.wg_config = {
    file = ../../secrets/wg_config.age;
    owner = "root";
    group = "root";
    mode = "600";
  };

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    configFile = config.age.secrets.wg_config.path;
  };

  services.resolved.enable = true;
}
