{ inputs, lib, ... }:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems.zfs = lib.mkForce false;

    loader = {
      timeout = lib.mkForce 0;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        autoReboot = true;
      };
    };
  };
}
