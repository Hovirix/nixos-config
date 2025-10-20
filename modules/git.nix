{ username, ... }:
{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = username;
        email = "hovirix@noreply.codeberg.org";
      };
    };
  };
}
