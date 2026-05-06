{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.boot;

in
{
  options.modules.boot = { };

  config = {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;

        systemd-boot = {
          enable = true;
          configurationLimit = 16;
          consoleMode = "0";
        };
      };
    };
  };
}
