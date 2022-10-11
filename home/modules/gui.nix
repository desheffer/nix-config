{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.gui;

in {
  options.modules.gui = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most GUI applications.";
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

    xdg.userDirs.extraConfig = {
      XDG_CODE_DIR = "$HOME/Code";
      XDG_DESKTOP_DIR = {};
      XDG_PUBLICSHARE_DIR = {};
      XDG_TEMPLATES_DIR = {};
    };
  };
}
