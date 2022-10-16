{ config, lib, ... }:

with lib;

let
  cfg = config.modules.boot;

in {
  options.modules.boot = {
  };

  config = {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = true;
          consoleMode = "0";
        };
      };

      plymouth.enable = true;
    };
  };
}
