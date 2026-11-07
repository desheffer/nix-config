{
  config,
  lib,
  pkgs,
  ...
}:

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
