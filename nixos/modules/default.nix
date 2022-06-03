{ lib, ... }:

with lib;

{
  system.stateVersion = mkForce "21.11";

  imports = [
    ./boot.nix
    ./gdm.nix
    ./general.nix
    ./gnome.nix
    ./fileSystems.nix
  ];
}
