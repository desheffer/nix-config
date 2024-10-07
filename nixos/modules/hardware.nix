{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

with lib;

let
  cfg = config.modules.hardware;

in
{
  options.modules.hardware = { };

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    hardware.enableRedistributableFirmware = true;
  };
}
