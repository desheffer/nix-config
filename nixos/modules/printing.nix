{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.printing;

in
{
  options.modules.printing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable printing support.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-brother-hll2340dw
        gutenprint
      ];
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name = "Brother_HL-L2300D_series";
          deviceUri = "usb://Brother/HL-L2300D%20series?serial=U63878J5N191508";
          model = "brother-HLL2340D-cups-en.ppd";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ 631 ];
  };
}
