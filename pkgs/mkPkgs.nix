inputs@{ nixpkgs, neovim-custom, ... }:

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
      neovim-custom = neovim-custom.packages.${system}.neovim;
    })
  ];

in
pkgs
