inputs@{ nixpkgs, ... }:

system:

let
  pkgs = import nixpkgs { inherit system config overlays; };

  config = {
    allowUnfree = true;
  };

  overlays = [
    # (final: prev: {
    # })
  ];

in
pkgs
