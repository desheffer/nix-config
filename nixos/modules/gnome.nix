{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.gnome;

in
{
  options.modules.gnome = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable GNOME desktop environment.";
      default = false;
    };
    wayland = mkOption {
      type = types.bool;
      description = "Whether to enable Wayland.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager = {
        defaultSession = if cfg.wayland then "gnome" else "gnome-xorg";

        gdm = {
          enable = true;
          wayland = true;
        };
      };

      desktopManager.gnome = {
        enable = true;

        favoriteAppsOverride = ''
          [org.gnome.shell]
          favorite-apps=[]
        '';
      };
    };

    services.gnome.core-utilities.enable = false;

    services.accounts-daemon.enable = true;
  };
}
