inputs@{ nixpkgs, nixpkgs-unstable, agenix, ... }:

system:

let
  pkgs = import nixpkgs {
    inherit system config overlays;
  };

  pkgs-unstable = import nixpkgs-unstable {
    inherit system config;
  };

  config = {
    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      inherit (pkgs-unstable) neovim-unwrapped;

      agenix = agenix.defaultPackage.${system};
    })
  ];

in
  pkgs
