{ lib, ... }:
  {
    system.stateVersion = lib.mkForce "21.11";

    imports = [
      ./options.nix

      ./modules/gdm.nix
      ./modules/general.nix
      ./modules/gnome.nix
    ];
  }
