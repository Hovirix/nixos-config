{ username, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "laptop";
    extraGroups = [ "wheel" ];
  };
}
