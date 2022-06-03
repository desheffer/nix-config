{ config, lib, ... }:

with lib;

let
  cfg = config.nixosConfig.gdm;

in {
  options.nixosConfig.gdm = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable GDM, the GNOME Display Manager.";
      default = config.nixosConfig.gnome.enable;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      displayManager.gdm.enable = true;
    };
  };
}
