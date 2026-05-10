{ username, ... }:
{
  services.getty = {
    autologinOnce = true;
    autologinUser = username;
  };

}
