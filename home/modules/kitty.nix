{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.kitty;

in {
  options.homeConfig.kitty = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Kitty terminal emulator.";
      default = config.homeConfig.gui.enable;
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
        wayland_titlebar_color = "#282828";
      };

      # theme = "Gruvbox Dark";
      settings = {
        selection_foreground  = "#ebdbb2";
        selection_background  = "#d65d0e";

        background            = "#282828";
        foreground            = "#ebdbb2";

        color0                = "#3c3836";
        color1                = "#cc241d";
        color2                = "#98971a";
        color3                = "#d79921";
        color4                = "#458588";
        color5                = "#b16286";
        color6                = "#689d6a";
        color7                = "#a89984";
        color8                = "#928374";
        color9                = "#fb4934";
        color10               = "#b8bb26";
        color11               = "#fabd2f";
        color12               = "#83a598";
        color13               = "#d3869b";
        color14               = "#8ec07c";
        color15               = "#fbf1c7";

        cursor                = "#bdae93";
        cursor_text_color     = "#665c54";

        url_color             = "#458588";
      };
    };
  };
}
