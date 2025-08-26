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
    wayland = mkOption {
      type = types.bool;
      description = "Whether to enable Wayland.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      defaultSession = if cfg.wayland then "gnome" else "gnome-xorg";
    };

    services.xserver = {
      enable = true;

      displayManager = {
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

      excludePackages = with pkgs; [ xterm ];
    };

    services.gnome.core-apps.enable = false;

    services.accounts-daemon.enable = true;

    environment.systemPackages = with pkgs; [ gnome-console ];

    # TODO: Move to `home/modules/kitty.nix` after 25.11 upgrade.
    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "kitty.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };
}
