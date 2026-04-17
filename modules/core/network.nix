{ hostname, ... }:
{
  networking = {

    enableIPv6 = false;
    hostName = "${hostname}";

    wireless.iwd = {
      enable = true;
      settings = {

        general = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
        };

        network = {
          NameResolvingService = "resolvconf";
        };
      };
    };
  };
}
