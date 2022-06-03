inputs@{ nixpkgs, home-manager, ... }:

{ hostname, system, nixosConfig, extraModules ? [], ... }:

let
  lib = import ../../lib inputs;

in {
  ${hostname} = nixpkgs.lib.nixosSystem {
    inherit system;

    pkgs = lib.mkPkgs system;
    modules = [
      {
        config.nixosConfig = nixosConfig;
      }
      ../modules

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }

      {
        networking = {
          hostName = hostname;
        };
      }
    ]
    ++ extraModules;
  };
}
