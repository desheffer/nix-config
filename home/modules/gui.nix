{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.gui;

in
{
  options.modules.gui = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable extra GUI applications.";
      default = config.modules.gnome.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
      qalculate-gtk
      vlc
      xsel
    ];
  };
}
