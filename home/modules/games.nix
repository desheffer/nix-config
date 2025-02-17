{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.games;

in
{
  options.modules.games = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable games.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      heroic
    ];
  };
}
