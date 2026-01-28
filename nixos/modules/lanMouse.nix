{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.lanMouse;

in
{
  options.modules.lanMouse = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Lan Mouse.";
      default = false;
    };

    config = mkOption {
      type = types.lines;
      description = "Lan Mouse configuration file.";
      default = "";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = {
        "lan-mouse.conf" = {
          text = cfg.config;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 4242 ];

    systemd.user.services.lan-mouse = {
      after = [
        "network.target"
        "graphical-session.target"
      ];
      description = "lan-mouse";
      wantedBy = [ "graphical-session.target" ];
      path = [ pkgs.lan-mouse ];
      serviceConfig.ExecStart = ''${pkgs.lan-mouse}/bin/lan-mouse --config /etc/lan-mouse.conf --daemon'';
      serviceConfig.Restart = "on-failure";
    };
  };
}
