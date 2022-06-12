{ config, lib, ... }:

with lib;

let
  cfg = config.nixosConfig.hidpi;

in {
  options.nixosConfig.hidpi = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to optimize for HiDPI displays.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    hardware.video.hidpi.enable = true;
  };
}
