{ config, lib, ... }:

with lib;

{
  options.homeConfig.gui = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most GUI applications.";
      default = config.homeConfig.gnome.enable;
    };
  };
}
