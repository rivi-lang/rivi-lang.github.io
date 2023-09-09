{

  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
  };

  outputs =
    inputs@{ self
    , flake-parts
    , nixpkgs
    , ...
    }:

    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      imports = [
        inputs.devenv.flakeModule
      ];

      perSystem = { pkgs, lib, config, system, ... }: {

        packages.default = pkgs.stdenv.mkDerivation {

          name = "rivi-website";
          src = ./.;

          phases = [ "unpackPhase" "buildPhase" ];
          buildPhase = ''
            cp favicon.svg $out
            cp robots.txt $out
            cp *.html $out
          '';

        };

        devenv.shells.default = { };

      };

    };
}
