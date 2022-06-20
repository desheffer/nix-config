{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixosConfig.docker;

in {
  options.nixosConfig.docker = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Docker.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;

      daemon.settings = {
        features = {
          buildkit = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      ctop
      docker-compose
    ];
  };
}
