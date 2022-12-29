inputs@{ nixpkgs, nixpkgs-gnome, ... }:

system:

let
  pkgs = import nixpkgs {
    inherit system config overlays;
  };

  pkgs-gnome = import nixpkgs-gnome {
    inherit system config;
  };

  config = {
    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      inherit (pkgs-gnome) gnome;
    })
  ];

in
pkgs
