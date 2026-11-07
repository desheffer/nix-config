{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ups;

in
{
  options.modules.ups = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable support for an Uninterruptible Power Supply.";
      default = false;
    };

    driver = lib.mkOption {
      type = lib.types.str;
      description = "Specify the program to run to talk to the UPS.";
      default = "usbhid-ups";
    };

    password = lib.mkOption {
      type = lib.types.str;
      description = "The user's (clear text) password";
    };
  };

  config = lib.mkIf cfg.enable {
    power.ups = {
      enable = true;

      ups."primary" = {
        driver = cfg.driver;
        port = "auto";
      };

      users.upsmon = {
        passwordFile = "/etc/nut/password";
        upsmon = "primary";
      };

      upsmon.monitor."primary".user = "upsmon";
    };

    environment.etc = {
      "nut/password" = {
        text = cfg.password;
      };
    };
  };
}
