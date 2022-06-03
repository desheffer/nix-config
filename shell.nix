# This script is used when initializing a `nix-shell`. It exists to work around
# a catch-22: `nix develop` uses flakes and flakes specify their dependencies,
# but flakes need certain dependencies to run in the first place.
{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [
    git
    git-crypt
    nixFlakes
  ];
}
