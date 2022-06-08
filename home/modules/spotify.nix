{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.spotify;

in {
  options.homeConfig.spotify = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Spotify.";
      default = config.homeConfig.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (spotify.override {
        deviceScaleFactor = 2;
      })
    ];
  };
}
