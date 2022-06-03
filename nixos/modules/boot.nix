{ config, lib, ... }:

with lib;

{
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
