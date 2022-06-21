{ config, lib, ... }:

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
}
