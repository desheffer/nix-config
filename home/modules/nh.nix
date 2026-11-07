{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nh;

in
{
  options.modules.nh = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable nh.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/desheffer/Code/nix-config";
    };
  };
}
