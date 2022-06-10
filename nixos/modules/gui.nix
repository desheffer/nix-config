{ config, lib, ... }:

with lib;

let
  cfg = config.nixosConfig.gui;

in {
  options.nixosConfig.gui = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most GUI applications.";
      default = config.nixosConfig.gnome.enable;
    };
  };
}
