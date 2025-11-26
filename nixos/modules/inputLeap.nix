{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.inputLeap;

in
{
  options.modules.inputLeap = {
    enableServer = mkOption {
      type = types.bool;
      description = "Whether to enable the Input Leap server.";
      default = false;
    };

    config = mkOption {
      type = types.lines;
      description = "Input Leap configuration file.";
      default = "";
    };

    enableClient = mkOption {
      type = types.bool;
      description = "Whether to enable the Input Leap client.";
      default = false;
    };

    serverAddress = mkOption {
      type = types.str;
      description = "Address of the Input Leap server.";
      default = "";
    };
  };

  config = mkIf (cfg.enableServer || cfg.enableClient) {
    environment = {
      etc = {
        "InputLeap.conf" = {
          text = cfg.config;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 24800 ];

    systemd.user.services.input-leap-server = mkIf cfg.enableServer {
      after = [
        "network.target"
        "graphical-session.target"
      ];
      description = "input-leap server";
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.input-leap ];
      serviceConfig.ExecStart = ''${pkgs.input-leap}/bin/input-leaps -f --config /etc/InputLeap.conf --disable-crypto'';
      serviceConfig.Restart = "on-failure";
    };

    systemd.user.services.input-leap-client = mkIf cfg.enableClient {
      after = [
        "network.target"
        "graphical-session.target"
      ];
      description = "input-leap client";
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.input-leap ];
      serviceConfig.ExecStart = ''${pkgs.input-leap}/bin/input-leapc -f --disable-crypto "${cfg.serverAddress}"'';
      serviceConfig.Restart = "on-failure";
    };
  };
}
