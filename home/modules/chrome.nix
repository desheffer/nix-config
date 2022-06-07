{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.chrome;

in {
  options.homeConfig.chrome = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Chrome.";
      default = config.homeConfig.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome.override {
        commandLineArgs = [
          "--enable-features=WebUIDarkMode"
          "--force-dark-mode"
        ];
      };
    };
  };
}
