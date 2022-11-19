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
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;

      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      (steam.override {
        extraProfile = optionalString config.modules.hidpi.enable ''
          export GDK_SCALE=2
        '';
      })
    ];
  };
}
