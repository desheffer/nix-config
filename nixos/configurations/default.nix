inputs@{ ... }:

let
  lib = import ../../lib inputs;

in
lib.mergeAttrs [
  (import ./argent.nix inputs)
  (import ./astral.nix inputs)
  (import ./iso.nix inputs)
]
