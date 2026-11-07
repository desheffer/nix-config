{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.nvidia;

in
{
  options.modules.nvidia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Nvidia options.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia.open = true;

    environment.systemPackages = with pkgs; [ nvtopPackages.full ];
  };
}
