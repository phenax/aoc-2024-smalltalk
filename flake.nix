{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      shell = { pkgs }: pkgs.mkShell {
        buildInputs = with pkgs; [
          gnu-smalltalk
          just
          (pkgs.writeShellScriptBin "smalltalk" ''
            ${gnu-smalltalk}/bin/gst "$@"
          '')
        ];
      };
    in flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in { devShells.default = shell { inherit pkgs; }; });
}
