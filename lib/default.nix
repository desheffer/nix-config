inputs@{ ... }:
  {
    mkDevShell = import ./mkDevShell.nix inputs;
    mkHomeManagerConfiguration = import ./mkHomeManagerConfiguration.nix inputs;
    mkNixosConfiguration = import ./mkNixosConfiguration.nix inputs;
    mkNixosUserConfiguration = import ./mkNixosUserConfiguration.nix inputs;
    mkPkgs = import ./mkPkgs.nix inputs;
  }
