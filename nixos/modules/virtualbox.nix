{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.virtualbox;

in
{
  options.modules.virtualbox = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable VirtualBox (host).";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;
  };
}
