{ config, lib, ... }:
  lib.mkIf config.hostRoles.gnome {
    services.xserver = {
      enable = true;

      desktopManager.gnome = {
        enable = true;

        favoriteAppsOverride = ''
          [org.gnome.shell]
          favorite-apps=[]
        '';
      };
    };

    services.gnome.core-utilities.enable = false;
  }
