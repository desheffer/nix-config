inputs@{ nixpkgs, home-manager, impermanence, secrets, ... }:

{ hostname, system, modules, ... }:

let
  lib = import ../../lib inputs;

in
{
  ${hostname} = nixpkgs.lib.nixosSystem {
    inherit system;

    pkgs = lib.mkPkgs system;
    modules = [
      ../modules

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }

      impermanence.nixosModules.impermanence

      secrets.nixosModules.secrets

      {
        networking.hostName = hostname;
      }
    ]
    ++ modules;
  };
}
