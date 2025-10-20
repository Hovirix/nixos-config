{
  boot.initrd.systemd.suppressedUnits = [ "emergency.service" "emergency.target" ];

  systemd = {
    enableEmergencyMode = false;

    settings.Manager = {
      runtimeTime = "15s";
      rebootTime = "30s";
      kexecTime = "1m";
    };

    services = {
      # Unused
      pre-sleep.enable = false;
      prepare-kexec.enable = false;
      systemd-rfkill.enable = false;
      systemd-hibernate-clear.enable = false;
      systemd-networkd-wait-online.enable = false;

      systemd-journald.serviceConfig = {
        UMask = 0077;
        PrivateNetwork = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
      };
    };
  };
}
