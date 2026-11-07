{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.ssh;

in
{
  options.modules.ssh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the OpenSSH secure shell daemon.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
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
