{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.hidpi;

in
{
  options.modules.hidpi = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to optimize for HiDPI displays.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  };
}
