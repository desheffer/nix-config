{ config, lib, ... }:

with lib;

{
  options.homeConfig.cli = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most CLI applications.";
      default = false;
    };
  };
}
