{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [ vm-curator ];
  users.users.${username}.extraGroups = [ "kvm" ];
}
