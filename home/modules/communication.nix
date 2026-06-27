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
    programs.discord = {
      enable = true;
      settings.SKIP_HOST_UPDATE = true;
    };

    home.packages = with pkgs; [
      slack
      zoom-us
    ];
  };
}
