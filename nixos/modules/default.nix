{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  system.stateVersion = mkForce "21.11";

  imports = [
    ./autoUpgrade.nix
    ./barrier.nix
    ./boot.nix
    ./cli.nix
    ./docker.nix
    ./fileSystems.nix
    ./flatpak.nix
    ./gnome.nix
    ./gui.nix
    ./hardware.nix
    ./journald.nix
    ./locale.nix
    ./nix.nix
    ./nvidia.nix
    ./printing.nix
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
