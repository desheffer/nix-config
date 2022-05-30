{ config, lib, pkgs, ... }:
  lib.mkIf config.userRoles.gnome {
    home.packages = with pkgs; [
      gnome.dconf-editor
      gnome.nautilus
    ];
  }
