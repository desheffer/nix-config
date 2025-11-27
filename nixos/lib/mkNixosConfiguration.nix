inputs@{
  nixpkgs,
  home-manager,
  impermanence,
  secrets,
  nix-flatpak,
  ...
}:

{
  hostname,
  system,
  permittedInsecurePackages ? [ ],
  modules,
  ...
}:

let
  lib = import ../../lib inputs;

in
{
  ${hostname} = nixpkgs.lib.nixosSystem {
    pkgs = lib.mkPkgs {
      inherit system permittedInsecurePackages;
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

      secrets.nixosModules.secrets

      nix-flatpak.nixosModules.nix-flatpak

      { networking.hostName = hostname; }
    ]
    ++ modules;
  };
}
