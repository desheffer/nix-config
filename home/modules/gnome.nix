{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.gnome;

in
{
  options.modules.gnome = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable GNOME with most GUI applications.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    dconf.settings = {
      "ca/desrt/dconf-editor" = {
        show-warning = false;
      };

      "org/gnome/desktop/datetime" = {
        automatic-timezone = true;
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "compose:ralt" ];
      };

      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        clock-show-seconds = true;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
        icon-theme = "Tela";
        show-battery-percentage = true;
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = hm.gvariant.mkUint32 250;
        repeat-interval = hm.gvariant.mkUint32 30;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        disable-while-typing = false;
        speed = 0.5;
        tap-to-click = false;
      };

      "org/gnome/desktop/privacy" = {
        old-files-age = hm.gvariant.mkUint32 7;
        remember-recent-files = false;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };

      "org/gnome/desktop/screensaver" = {
        user-switch-enabled = false;
      };

      "org/gnome/desktop/session" = {
        idle-delay = hm.gvariant.mkUint32 3600;
      };

      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };

      "org/gnome/desktop/wm/preferences" = {
        action-middle-click-titlebar = "lower";
        audible-bell = false;
        button-layout = "close,minimize,maximize:";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = hm.gvariant.mkUint32 3000;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "interactive";
        sleep-inactive-ac-type = "nothing";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "dash-to-panel@jderose9.github.com"
        ];
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "google-chrome.desktop"
          "spotify.desktop"
          "kitty.desktop"
        ];
        welcome-dialog-last-shown-version = "999";
      };

      "org/gnome/shell/extensions/dash-to-panel" = {
        animate-app-switch = false;
        animate-window-launch = false;
        appicon-margin = 4;
        click-action = "CYCLE";
        dot-position = "BOTTOM";
        dot-style-focused = "DOTS";
        dot-style-unfocused = "DOTS";
        focus-highlight = false;
        hot-keys = true;
        multi-monitors = false;
        panel-element-positions = ''
          {"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"1":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"centerMonitor"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
        '';
        show-tooltip = false;
        show-window-previews = false;
        trans-dynamic-anim-target = 0.25;
        trans-dynamic-behavior = "ALL_WINDOWS";
        trans-dynamic-distance = 20;
        trans-gradient-bottom-opacity = 0;
        trans-gradient-top-opacity = 0;
        trans-panel-opacity = 0;
        trans-use-custom-bg = true;
        trans-use-custom-gradient = true;
        trans-use-custom-opacity = true;
        trans-use-dynamic-opacity = true;
      };

      "org/gnome/system/location" = {
        enabled = true;
      };
    };

    home.packages = with pkgs; [
      dconf-editor
      eog
      evince
      file-roller
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-panel
      nautilus
      roboto
      tela-icon-theme
    ];
  };
}
