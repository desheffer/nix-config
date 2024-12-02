{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.kitty;

in
{
  options.modules.kitty = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Kitty terminal emulator.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font = {
        package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
        name = "JetBrainsMono Nerd Font Mono";
        size = 11;
      };

      settings = {
        enable_audio_bell = false;
        window_alert_on_bell = false;
        wayland_titlebar_color = "#282828";
      };

      themeFile = "gruvbox-dark";
    };
  };
}
