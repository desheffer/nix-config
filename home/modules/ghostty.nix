{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ghostty;

  mkIcon =
    size: hash:
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lukejanicke/ghostty-app-icons/c8e41bff657cd5168ab6217998141288b387b64f/iconsets/ghostty-black.iconset/icon_${size}.png";
      sha256 = hash;
    };

in
{
  options.modules.ghostty = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Ghostty terminal emulator.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;

      enableZshIntegration = true;

      settings = {
        font-family = "JetBrainsMono Nerd Font Mono";
        font-size = 11;
        adjust-cell-height = "-2";
        theme = "Gruvbox Dark";
        maximize = true;
        bell-features = "no-audio";
        window-inherit-working-directory = true;
        keybind = [
          "ctrl+b>ctrl+b=text:\\x02"

          "ctrl+b>c=new_tab"
          "ctrl+page_down=unbind"
          "alt+page_down=next_tab"
          "ctrl+page_up=unbind"
          "alt+page_up=previous_tab"

          "ctrl+b>shift+backslash=new_split:right"
          "ctrl+b>minus=new_split:down"
          "alt+left=goto_split:left"
          "alt+right=goto_split:right"
          "alt+up=goto_split:top"
          "alt+down=goto_split:bottom"

          "ctrl+b>p=toggle_command_palette"
          "ctrl+b>x=close_surface"
          "ctrl+b>z=toggle_split_zoom"

          "ctrl+enter=unbind"
          "super+enter=toggle_fullscreen"
        ];
      };
    };

    xdg.dataFile = {
      "icons/Tela/scalable/apps/com.mitchellh.ghostty.png".source =
        mkIcon "512x512" "1gwnhcxb98scx7rnj18kp03m6q6i3097xfc8a0xkzbkq8nf83706";
      "icons/Tela/scalable@2x/apps/com.mitchellh.ghostty.png".source =
        mkIcon "512x512" "1gwnhcxb98scx7rnj18kp03m6q6i3097xfc8a0xkzbkq8nf83706";
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Console.desktop"
      ];
    };
  };
}
