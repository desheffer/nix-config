{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

with lib;

let
  cfg = config.modules.journald;

in
{
  options.modules.journald = { };

  config = {
    services.journald.extraConfig = ''
      SystemMaxUse=1G
    '';
  };
}
