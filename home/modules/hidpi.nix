{ config, lib, ... }:

with lib;

let
  cfg = config.homeConfig.hidpi;

in {
  options.homeConfig.hidpi = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to optimize for HiDPI displays.";
      default = false;
    };
  };
}
