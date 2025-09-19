{
  config,
  lib,
  pkgs,
  ...
}:

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
        extraProfile = optionalString cfg.enableHidpi ''
          export STEAM_FORCE_DESKTOPUI_SCALING=2;
        '';
      };

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [ r2modman ];
  };
}
