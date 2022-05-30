{ config, lib, pkgs, ... }:
  lib.mkIf config.userRoles.kitty {
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
        cursor               = "#928373";
        background           = "#282828";
        foreground           = "#fbf1c7";
        selection_foreground = "#928374";
        selection_background = "#ebdbb2";
        color0               = "#282828";
        color1               = "#cc241d";
        color2               = "#98971a";
        color3               = "#d79921";
        color4               = "#458588";
        color5               = "#b16286";
        color6               = "#689d6a";
        color7               = "#a89984";
        color8               = "#7c6f64";
        color9               = "#fb4934";
        color10              = "#b8bb26";
        color11              = "#fabd2f";
        color12              = "#83a598";
        color13              = "#d3869b";
        color14              = "#8ec07c";
        color15              = "#fbf1c7";
      };
    };
  }
