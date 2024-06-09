{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.ups;

in
{
  options.modules.ups = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable support for an Uninterruptible Power Supply.";
      default = false;
    };

    driver = mkOption {
      type = types.str;
      description = "Specify the program to run to talk to the UPS.";
      default = "usbhid-ups";
    };
  };

  config = mkIf cfg.enable {
    power.ups = {
      enable = true;

      ups."primary" = {
        driver = cfg.driver;
        port = "auto";
      };

      users.upsmon = {
        passwordFile = "/etc/nut/password";
        upsmon = "master";
      };

      upsmon.monitor."primary".user = "upsmon";
    };

    environment.etc = {
      "nut/password" = {
        text = "1234";
      };
    };
  };
}
