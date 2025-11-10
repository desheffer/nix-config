{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.flatpak;

in
{
  options.modules.flatpak = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Flatpack.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
