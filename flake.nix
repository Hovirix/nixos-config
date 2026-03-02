{
  description = "HX NixOS configs dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixfmt
            deadnix
            statix
          ];
        };

        docs = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
          ];
        };
      };
    };
}
