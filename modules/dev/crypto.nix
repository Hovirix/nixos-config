{
  programs.gnupg = {
    agent.enable = true;
  };

  programs.ssh = {
    startAgent = true;
  };
}
