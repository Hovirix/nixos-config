{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [ quickemu ];
  users.users.${username}.extraGroups = [ "kvm" ];
}
