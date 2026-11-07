{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.boot;

in
{
  options.modules.boot = {
    secureBoot.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Secure Boot with lanzaboote.";
      default = true;
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfg.secureBoot.enable (with pkgs; [ sbctl ]);

    boot = {
      initrd = {
        systemd.enable = true;
        verbose = false;
      };

      consoleLogLevel = 0;
      kernelParams = [
        "quiet"
        "splash"
      ];

      plymouth.enable = true;

      lanzaboote = {
        enable = cfg.secureBoot.enable;
        pkiBundle = "/var/lib/sbctl";
      };

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;

        systemd-boot = {
          enable = lib.mkForce (!cfg.secureBoot.enable);
          configurationLimit = 3;
          consoleMode = "0";
        };
      };
    };
  };
}
