{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ssh;

in
{
  options.modules.ssh = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the OpenSSH secure shell daemon.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
