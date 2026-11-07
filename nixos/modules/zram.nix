{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.zram;

in
{
  options.modules.zram = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable in-memory compressed devices and swap space provided by the zram kernel module.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable { zramSwap.enable = true; };
}
