{ username, ... }:
{
  preservation = {
    enable = true;

    preserveAt."/persist" = {
      directories = [
        "/etc/ssh"
        "/var/lib/iwd"
        "/var/lib/sbctl"
        "/var/lib/nixos"
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
          ".local"
          ".local"
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
