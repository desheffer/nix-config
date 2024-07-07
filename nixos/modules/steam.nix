{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.steam;

in
{
  options.modules.steam = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Steam.";
      default = config.modules.gui.enable;
    };

    enableHidpi = mkOption {
      type = types.bool;
      description = "Whether to enable HiDPI scaling.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = mkIf cfg.enableHidpi {
          GDK_SCALE = 2;
        };
      };

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
  };
}
