{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.autoUpgrade;

in
{
  options.modules.autoUpgrade = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to periodically pull in updates from this flake.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = "github:desheffer/nix-config";
    };
  };
}
