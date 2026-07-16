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
  options.modules.boot = {
    secureBoot.enable = mkOption {
      type = types.bool;
      description = "Whether to enable Secure Boot with lanzaboote.";
      default = true;
    };
  };

  config = {
    environment.systemPackages = mkIf cfg.secureBoot.enable (with pkgs; [ sbctl ]);

    boot = {
      initrd.systemd.enable = true;

      lanzaboote = {
        enable = cfg.secureBoot.enable;
        pkiBundle = "/var/lib/sbctl";
      };

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;

        systemd-boot = {
          enable = mkForce (!cfg.secureBoot.enable);
          configurationLimit = 3;
          consoleMode = "0";
        };
      };
    };
  };
}
