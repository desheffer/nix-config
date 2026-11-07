{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.steam;

in
{
  options.modules.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Steam.";
      default = config.modules.gui.enable;
    };

    enableHidpi = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable HiDPI scaling.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraProfile = lib.optionalString cfg.enableHidpi ''
          export STEAM_FORCE_DESKTOPUI_SCALING=2;
        '';
      };

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [ r2modman ];
  };
}
