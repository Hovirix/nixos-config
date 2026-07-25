{ config, ... }:
{
  sops = {
    secrets."wireguard/config" = {
      owner = "root";
      group = "root";
      mode = "0600";
    };
  };

  networking = {
    firewall.checkReversePath = "loose";
    wg-quick.interfaces.wg0 = {
      autostart = true;
      configFile = config.sops.secrets."wireguard/config".path;
    };
  };
}
