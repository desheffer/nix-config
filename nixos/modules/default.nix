{ lib, ... }:

with lib;

{
  system.stateVersion = mkForce "21.11";

  imports = [
    ./agenix.nix
    ./barrier.nix
    ./boot.nix
    ./cli.nix
    ./docker.nix
    ./fileSystems.nix
    ./gnome.nix
    ./gui.nix
    ./hardware.nix
    ./hidpi.nix
    ./locale.nix
    ./nix.nix
    ./ssh.nix
    ./steam.nix
    ./zram.nix
  ];
}
