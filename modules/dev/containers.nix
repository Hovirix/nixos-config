{ username, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      # rootless = {
      #   enable = true;
      #   setSocketVariable = true;
      # };
    };

    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    #   autoPrune.enable = true;
    # };
  };
  users.users.${username}.extraGroups = [ "docker" ];
}
