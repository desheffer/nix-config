{ config, lib, pkgs, ... }:

with lib;

{
  system.stateVersion = mkForce "21.11";

  imports = [
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
    ./nvidia.nix
    ./secrets.nix
    ./ssh.nix
    ./steam.nix
    ./sudo.nix
    ./ups.nix
    ./users.nix
    ./virtualbox.nix
    ./zram.nix
  ];
}
