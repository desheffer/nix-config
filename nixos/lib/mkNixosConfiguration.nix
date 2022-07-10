inputs@{ nixpkgs, agenix, home-manager, kmonad, ... }:

{ hostname, system, modules, ... }:

let
  lib = import ../../lib inputs;

in {
  ${hostname} = nixpkgs.lib.nixosSystem {
    inherit system;

    pkgs = lib.mkPkgs system;
    modules = [
      ../modules

      agenix.nixosModule
      home-manager.nixosModules.home-manager
      kmonad.nixosModules.default

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        networking = {
          hostName = hostname;
        };
      }
    ]
    ++ modules;
  };
}
