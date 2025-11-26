{
  config,
  lib,
  pkgs,
  ...
}:

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
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];
    };

    services.displayManager = {
      defaultSession = "gnome";

      gdm = {
        enable = true;
        wayland = true;
      };
    };

    services.desktopManager.gnome = {
      enable = true;

      favoriteAppsOverride = ''
        [org.gnome.shell]
        favorite-apps=[]
      '';
    };

    services.gnome.core-apps.enable = false;

    services.accounts-daemon.enable = true;

    environment.systemPackages = with pkgs; [ gnome-console ];
  };
}
