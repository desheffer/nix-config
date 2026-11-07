{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.communication;

in
{
  options.modules.communication = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable communication tools.";
      default = config.modules.gui.enable;
    };
  };

  config = lib.mkIf cfg.enable {
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
