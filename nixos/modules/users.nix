{
  config,
  lib,
  pkgs,
  flakeInputs,
  ...
}:

let
  cfg = config.modules.users;
  passwords = flakeInputs.secrets.nixosModules.passwords;

in
{
  options.modules.users = { };

  config = {
    users.mutableUsers = false;
    users.users.root.initialHashedPassword = passwords.desheffer;
  };
}
