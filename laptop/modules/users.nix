{ username, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  services.getty = {
    autologinOnce = true;
    autologinUser = username;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
