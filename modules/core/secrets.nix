{
  sops = {
    defaultSopsFile = ../../secrets/laptop.yaml;
    age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
  };
}
