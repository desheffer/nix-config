{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.barrier;

in
{
  options.modules.barrier = {
    enableServer = mkOption {
      type = types.bool;
      description = "Whether to enable the Barrier server.";
      default = false;
    };

    config = mkOption {
      type = types.lines;
      description = "Barrier configuration file.";
      default = "";
    };

    enableClient = mkOption {
      type = types.bool;
      description = "Whether to enable the Barrier client.";
      default = false;
    };

    serverAddress = mkOption {
      type = types.str;
      description = "Address of the Barrier server.";
      default = "";
    };
  };

  config = mkIf (cfg.enableServer || cfg.enableClient) {
    environment = {
      etc = {
        "barrier.conf" = {
          text = cfg.config;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 24800 ];

    systemd.user.services.barrier-server = mkIf cfg.enableServer {
      after = [
        "network.target"
        "graphical-session.target"
      ];
      description = "barrier server";
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.barrier ];
      serviceConfig.ExecStart = ''${pkgs.barrier}/bin/barriers -f --config /etc/barrier.conf --disable-crypto'';
      serviceConfig.Restart = "on-failure";
    };

    systemd.user.services.barrier-client = mkIf cfg.enableClient {
      after = [
        "network.target"
        "graphical-session.target"
      ];
      description = "barrier client";
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.barrier ];
      serviceConfig.ExecStart = ''${pkgs.barrier}/bin/barrierc -f --disable-crypto "${cfg.serverAddress}"'';
      serviceConfig.Restart = "on-failure";
    };
  };
}
