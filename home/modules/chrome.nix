{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.chrome;

in
{
  options.modules.chrome = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Chrome.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome.override {
        commandLineArgs = [
          "--disable-features=HardwareMediaKeyHandling"
          "--disable-session-crashed-bubble"
          "--enable-features=WebUIDarkMode"
          "--force-dark-mode"
          "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'"
        ];
      };
    };
  };
}
