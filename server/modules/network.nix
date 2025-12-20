{ hostname, lib, ... }:
let
  ip = "192.168.1.20";
  interface = "enp1s0";
in
{
  services.resolved.enable = lib.mkForce false;

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks."10-ignore-containers" = {
      matchConfig.Name = "ve-*";
      linkConfig.Unmanaged = "yes";
    };
  };

  networking = {
    useDHCP = false;
    enableIPv6 = false;
    # useNetworkd = true; # Break containers network connectivity for no reason 
    dhcpcd.enable = false;
    modemmanager.enable = false;

    hostName = hostname;
    nameservers = [ ip ];

    defaultGateway = {
      inherit interface;
      address = "192.168.1.1";
    };

    interfaces.${interface} = {
      wakeOnLan.enable = true;
      ipv4.addresses = [{ address = ip; prefixLength = 24; }];
    };

    nat = {
      enable = true;
      enableIPv6 = false;
      externalInterface = interface;
      internalInterfaces = [ "ve-+" ];
    };

    firewall = {
      enable = true;
      allowPing = false;
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 80 443 ];
    };
  };
}
