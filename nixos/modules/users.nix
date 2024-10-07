{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.users;

in
{
  options.modules.users = { };

  config = {
    users.mutableUsers = false;
  };
}
