{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.ups;

in {
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
      ups."ups" = {
        driver = cfg.driver;
        port = "auto";
      };
    };

    environment.etc = {
      "nut/upsd.conf" = {
        text = ''
          LISTEN 127.0.0.1
        '';
      };
      "nut/upsd.users" = {
        text = ''
          [upsmon]
          password = 1234
          upsmon primary
        '';
      };
      "nut/upsmon.conf" = {
        text = ''
          MONITOR ups@localhost 1 upsmon 1234 primary
          SHUTDOWNCMD /run/current-system/sw/bin/poweroff
        '';
      };
    };

    systemd.services.upsd.preStart = ''
      mkdir -p /var/lib/nut -m 0700
    '';
  };
}
