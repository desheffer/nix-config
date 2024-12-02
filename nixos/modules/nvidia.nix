{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.nvidia;

in
{
  options.modules.nvidia = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Nvidia options.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia.open = false;

    environment.systemPackages = with pkgs; [ nvtopPackages.full ];
  };
}
