{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.zram;

in
{
  options.modules.zram = {
    enable = mkOption {
      type = types.bool;
      description = "Enable in-memory compressed devices and swap space provided by the zram kernel module.";
      default = true;
    };
  };

  config = mkIf cfg.enable { zramSwap.enable = true; };
}
