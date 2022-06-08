{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.slack;

in {
  options.homeConfig.slack = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Slack.";
      default = config.homeConfig.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
