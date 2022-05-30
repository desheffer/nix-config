inputs@{ nixpkgs, home-manager, ... }:
{ hostname, system, roles, modules, ... }:
  let
    lib = import ../lib inputs;
  in {
    ${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;

      pkgs = lib.mkPkgs system;
      modules = [
        {
          config.hostRoles = roles;
        }
        ../nixos

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }

        {
          imports = modules;
        }
      ];
    };
  }
