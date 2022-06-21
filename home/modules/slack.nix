{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.slack;

in {
  options.modules.slack = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Slack.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slack
    ];
  };
}
