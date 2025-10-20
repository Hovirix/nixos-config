{ username, lib, ... }:
{
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = "/home/${username}/nixos-homelab";
    flags = [ "--upgrade-all" "--commit-lock-file" ];
  };

  systemd.services.nixos-upgrade.serviceConfig.ExecStartPost = lib.mkAfter ''
    cd /home/${username}/nixos-homelab
    git commit --amend -m "AUTO UPDATE $(date -Iseconds)" --no-edit || true
  '';
}
