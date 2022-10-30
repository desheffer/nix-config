inputs@{ nixpkgs, agenix, ... }:

system:

let
  pkgs = import nixpkgs {
    inherit system config overlays;
  };

  config = {
    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      agenix = agenix.defaultPackage.${system};
    })
  ];

in
pkgs
