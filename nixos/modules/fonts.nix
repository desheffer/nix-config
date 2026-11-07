{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.fonts;

in
{
  options.modules.fonts = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to install fonts.";
      default = config.modules.gui.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
