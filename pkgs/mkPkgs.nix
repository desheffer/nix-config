inputs@{ nixpkgs, ... }:

{
  system,
  permittedInsecurePackages ? [ ],
  ...
}:

let
  pkgs = import nixpkgs { inherit system config overlays; };

  config = {
    inherit permittedInsecurePackages;

    allowUnfree = true;
  };

  overlays = [
    # (final: prev: {
    # })
  ];

in
pkgs
