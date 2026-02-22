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
      url = "https://raw.githubusercontent.com/lukejanicke/ghostty-app-icons/c8e41bff657cd5168ab6217998141288b387b64f/iconsets/ghostty-original.iconset/icon_${size}.png";
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
      };
    };

    xdg.dataFile = {
      "icons/hicolor/16x16/apps/com.mitchellh.ghostty.png".source =
        mkIcon "16x16" "1k4aajwk971m56cszz2vp5bv0xymgarw066lmpbsj1xb54g1aqxn";
      "icons/hicolor/32x32/apps/com.mitchellh.ghostty.png".source =
        mkIcon "32x32" "0clyxzm9z9023b34xgshin2c1ka6ak5y6g7fpb9a7vk29sa7a8fx";
      "icons/hicolor/128x128/apps/com.mitchellh.ghostty.png".source =
        mkIcon "128x128" "1pm9q2ly6p1a8fdxk5wf3jk2x9lfbb6sb33bda6ijwb7y4296f39";
      "icons/hicolor/256x256/apps/com.mitchellh.ghostty.png".source =
        mkIcon "256x256" "08gw2mv69zr5dq71d54hdahx3jz3s7fs50y8xk4v8vvaz0zcxzqw";
      "icons/hicolor/512x512/apps/com.mitchellh.ghostty.png".source =
        mkIcon "512x512" "1lf5h9yirqnx8c2qmvk29nq166cq3vgi7r6apbw3l05b8qab4sap";
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
