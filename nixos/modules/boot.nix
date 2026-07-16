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
    environment.systemPackages = with pkgs; [ sbctl ];

    boot = {
      initrd.systemd.enable = true;

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;

        systemd-boot = {
          enable = mkForce false;
          configurationLimit = 3;
          consoleMode = "0";
        };
      };
    };
  };
}
