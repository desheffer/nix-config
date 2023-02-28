inputs:

{
  mergeAttrs = builtins.foldl' (n: a: n // a) { };

  mkHomeManagerConfiguration = import ../home/lib/mkHomeManagerConfiguration.nix inputs;
  mkNixosConfiguration = import ../nixos/lib/mkNixosConfiguration.nix inputs;
  mkNixosUserConfiguration = import ../home/lib/mkNixosUserConfiguration.nix inputs;
  mkPkgs = import ../pkgs/mkPkgs.nix inputs;
}
