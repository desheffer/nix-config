{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.discord;

in
{
  options.modules.discord = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Discord.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
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
