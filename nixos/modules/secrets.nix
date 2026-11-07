{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.secrets;

in
{
  options.modules.secrets = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable secrets.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable { secrets.enable = true; };
}
