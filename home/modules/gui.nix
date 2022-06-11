{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.gui;

in {
  options.homeConfig.gui = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most GUI applications.";
      default = config.homeConfig.gnome.enable;
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
