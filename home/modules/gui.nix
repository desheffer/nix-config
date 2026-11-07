{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.gui;

in
{
  options.modules.gui = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable extra GUI applications.";
      default = config.modules.gnome.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.qalculate = {
      enable = true;
      package = pkgs.qalculate-gtk;
    };

    home.packages = with pkgs; [
      gimp
      vlc
      xsel
    ];
  };
}
