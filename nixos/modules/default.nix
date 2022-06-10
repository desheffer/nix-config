{ lib, ... }:

with lib;

{
  system.stateVersion = mkForce "21.11";

  imports = [
    ./boot.nix
    ./fileSystems.nix
    ./general.nix
    ./gnome.nix
    ./gui.nix
    ./steam.nix
  ];
}
