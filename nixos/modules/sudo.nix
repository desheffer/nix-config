{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.sudo;

in
{
  options.modules.sudo = { };

  config = {
    security.sudo.extraConfig = ''
      Defaults lecture = never
      Defaults timestamp_timeout = 15
    '';
  };
}
