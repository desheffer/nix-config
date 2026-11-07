{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.music;

in
{
  options.modules.music = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable music applications.";
      default = config.modules.gui.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
      pear-desktop
    ];
  };
}
