{ pkgs, lib, inputs, ... }:
{
  fonts.fontconfig.enable = false;

  xdg = {
    mime.enable = false;
    icons.enable = false;
    menus.enable = false;
    sounds.enable = false;
    autostart.enable = false;
  };

  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    dev.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  programs = {
    nano.enable = false;
    command-not-found.enable = false;
  };

  environment = {

    stub-ld.enable = false;
    defaultPackages = lib.mkForce [ ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    systemPackages = with pkgs; [
      btop
      yazi
      helix
      lynis
      inputs.agenix.packages.x86_64-linux.default
    ];
  };
}
