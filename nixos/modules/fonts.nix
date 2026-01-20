{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.fonts;

in
{
  options.modules.fonts = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to install fonts.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
