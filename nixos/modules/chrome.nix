{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.chrome;

in
{
  options.modules.chrome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Chrome policies.";
      default = config.modules.gui.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extraOpts = {
        CommandLineFlagSecurityWarningsEnabled = false;
      };
    };
  };
}
