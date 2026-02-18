{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ai;

in
{
  options.modules.ai = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable AI tools.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
    ];
  };
}
