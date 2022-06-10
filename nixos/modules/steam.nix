{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixosConfig.steam;

in {
  options.nixosConfig.steam = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Steam.";
      default = config.nixosConfig.gui.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      (steam.override {
        extraProfile = ''
          export GDK_SCALE=2
        '';
      })
    ];
  };
}
