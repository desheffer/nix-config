{ lib, ... }:

with lib;

{
  system.stateVersion = mkForce "21.11";

  imports = [
    ./agenix.nix
    ./boot.nix
    ./cli.nix
    ./docker.nix
    ./fileSystems.nix
    ./general.nix
    ./gnome.nix
    ./gui.nix
    ./hidpi.nix
    ./kmonad.nix
    ./steam.nix
  ];
}
