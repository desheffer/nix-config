{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.spotify;

in
{
  options.modules.spotify = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Spotify.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ spotify ]; };
}
