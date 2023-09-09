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

          buildInputs = with pkgs; [
            pandoc
          ];

          buildPhase = ''
            mkdir -p $out

            cp favicon.svg robots.txt rss.xml $out
            pandoc index.md --katex -o $out/index.html
          '';

        };

        devenv.shells.default = {
          packages = with pkgs; [
            pandoc
          ];
        };

      };

    };
}
