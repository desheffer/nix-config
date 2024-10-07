{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.communication;

in
{
  options.modules.communication = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable communication tools.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      slack
      zoom-us
    ];

    xdg.configFile = {
      "discord/settings.json" = {
        text = ''
          {
            "SKIP_HOST_UPDATE": true
          }
        '';
      };
    };
  };
}
