inputs@{
  nixpkgs,
  home-manager,
  impermanence,
  disko,
  secrets,
  ...
}:

{
  hostname,
  system,
  permittedInsecurePackages ? [ ],
  allowInsecurePredicate ? null,
  modules,
  ...
}:

let
  lib = import ../../lib inputs;

in
{
  ${hostname} = nixpkgs.lib.nixosSystem {
    pkgs = lib.mkPkgs {
      inherit system permittedInsecurePackages allowInsecurePredicate;
    };

    specialArgs = {
      flakeInputs = inputs;
    };

    modules = [
      ../modules

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }

      impermanence.nixosModules.impermanence

      disko.nixosModules.disko

      secrets.nixosModules.secrets

      { networking.hostName = hostname; }
    ]
    ++ modules;
  };
}
