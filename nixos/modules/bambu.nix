{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.bambu-studio;

in
{
  options.modules.bambu-studio = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Bambu Studio.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      packages = [ "com.bambulab.BambuStudio" ];
    };
  };
}
