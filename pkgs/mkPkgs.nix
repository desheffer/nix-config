inputs@{ nixpkgs, agenix, neovim-custom, ... }:

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
      agenix = agenix.packages.${system}.agenix;
      neovim-custom = neovim-custom.packages.${system}.neovim;
    })
  ];

in
pkgs
