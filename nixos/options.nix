{ config, lib, ... }:
  with lib; {
    options.hostRoles = {
      gdm = mkOption {
        type = types.bool;
        description = "Whether to enable GDM, the GNOME Display Manager..";
        default = config.hostRoles.gnome;
      };
      gnome = mkOption {
        type = types.bool;
        description = "Whether to enable GNOME desktop environment.";
        default = false;
      };
    };
  }
