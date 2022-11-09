{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.hidpi;

in
{
  options.modules.hidpi = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to optimize for HiDPI displays.";
      default = false;
    };
  };
}
