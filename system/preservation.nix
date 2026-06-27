{ username, ... }:
{
  preservation = {
    enable = true;

    preserveAt."/persist" = {
      directories = [
        "/etc/ssh"
        "/var/lib/flatpak"
        "/var/lib/iwd"
        "/var/lib/nixos"
        "/var/lib/sbctl"
        "/var/log"
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];

      users.${username} = {
        directories = [
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".password-store";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
          ".config"
          ".local"
          ".var"
          "Documents"
          "Downloads"
          "Pictures"
          "Projects"
          "Vm"
        ];
      };
    };
  };
}
