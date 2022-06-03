inputs@{ ... }:

let
  lib = import ../../lib inputs;

in lib.mergeAttrs [
  (import ./argent.nix inputs)
  (import ./nixos-vm.nix inputs)
]
