inputs@{ nixpkgs, ... }:

let
  lib = import ../../lib inputs;

in
lib.mergeAttrs [
  (lib.mkHomeManagerConfiguration rec {
    hostname = system;
    system = "x86_64-linux";
    username = "root";
    modules = [ { modules.cli.enable = true; } ];
  })

  (lib.mkHomeManagerConfiguration rec {
    hostname = system;
    system = "x86_64-linux";
    username = "desheffer";
    modules = [ { modules.cli.enable = true; } ];
  })
]
