{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.nh;

in
{
  options.modules.nh = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable nh.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/desheffer/Code/nix-config";
    };
  };
}
