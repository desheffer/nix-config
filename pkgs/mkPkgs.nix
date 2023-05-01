inputs@{ nixpkgs, ... }:

system:

let
  pkgs = import nixpkgs {
    inherit system config overlays;
  };

  # Lock GNOME due to sound picker bug.
  # Include LibreOffice because it has GNOME inputs.
  # TODO: Remove when bug is fixed.
  # SEE: https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/6207
  nixpkgs-gnome = pkgs.fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = "899e7ca";
    sha256 = "fVbG427suESAEb8/P47O/zD/G9BSeFxLh94IUzgOchs=";
  };
  pkgs-gnome = import nixpkgs-gnome {
    inherit system config;
  };

  config = {
    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      inherit (pkgs-gnome) gnome libreoffice;
    })
  ];

in
pkgs
