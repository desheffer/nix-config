{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.docker;

in
{
  options.modules.docker = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Docker.";
      default = false;
    };

    enableNvidia = mkOption {
      type = types.bool;
      description = "Whether to enable nvidia-docker wrapper.";
      default = config.modules.nvidia.enable;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableNvidia = cfg.enableNvidia;

      daemon.settings = {
        features = {
          buildkit = true;
        };
        shutdown-timeout = 5;
      };
    };

    environment.systemPackages = with pkgs; [
      ctop
    ];

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
