{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.music;

in
{
  options.modules.music = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable music applications.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
      youtube-music
    ];
  };
}
