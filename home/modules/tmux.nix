{ config, lib, ... }:

with lib;

let
  cfg = config.homeConfig.tmux;

in {
  options.homeConfig.tmux = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable tmux.";
      default = config.homeConfig.cli.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}
