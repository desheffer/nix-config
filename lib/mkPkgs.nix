inputs@{ nixpkgs, nixpkgs-unstable, agenix, kmonad, ... }:

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
    })
    agenix.overlay
    kmonad.overlays.default
  ];

in
  pkgs
