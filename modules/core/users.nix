{ username, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
