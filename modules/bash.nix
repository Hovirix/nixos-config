{
  programs.bash.shellAliases = {

    la = "ls -a";
    ll = "ls -l";
    lr = "ls -R";
    ".." = "cd ..";
    grep = "grep --color=auto";

    # Containers
    immich = "sudo nixos-container root-login immich";
    adguard = "sudo nixos-container root-login adguard";
    traefik = "sudo nixos-container root-login traefik";
    authelia = "sudo nixos-container root-login authelia";
    nextcloud = "sudo nixos-container root-login nextcloud";
    vaultwarden = "sudo nixos-container root-login vaultwarden";

    # NixOS
    hxd = "hx ~/nixos-homelab";
    update = "nix flake update --flake ~/nixos-homelab";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-homelab";
    garbage = "sudo nix-collect-garbage -d && sudo nix-store --gc && sudo nix-store --repair --verify --check-contents && sudo nix-store --optimise -vvv";
  };
}

