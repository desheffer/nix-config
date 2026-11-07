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
}
