inputs@{ nixpkgs, nixpkgs-unstable, ... }:

{
  system,
  permittedInsecurePackages ? [ ],
  ...
}:

let
  pkgs = import nixpkgs { inherit system config overlays; };

  pkgs-unstable = import nixpkgs-unstable { inherit system config; };

  config = {
    inherit permittedInsecurePackages;

    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      opencode = pkgs-unstable.opencode;
    })
  ];

in
pkgs
