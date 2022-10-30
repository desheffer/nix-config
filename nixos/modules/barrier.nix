{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.barrier;

in
{
  options.modules.barrier = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Barrier.";
      default = false;
    };

    config = mkOption {
      type = types.lines;
      description = "Barrier configuration file.";
      default = "";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        barrier
      ];

      etc = {
        "barrier.conf" = {
          text = cfg.config;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 24800 ];

    systemd.user.services.barrier-server = {
      after = [ "network.target" "graphical-session.target" ];
      description = "barrier server";
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.barrier ];
      serviceConfig.ExecStart = ''${pkgs.barrier}/bin/barriers -f --config /etc/barrier.conf --disable-crypto'';
      serviceConfig.Restart = "on-failure";
    };
  };
}
