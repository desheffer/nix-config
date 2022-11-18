{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.secrets;

in
{
  options.modules.secrets = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable secrets.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    secrets.enable = true;
  };
}
