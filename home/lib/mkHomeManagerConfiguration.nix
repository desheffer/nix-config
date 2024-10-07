inputs@{ home-manager, neovim-config, ... }:

{
  hostname,
  system,
  username,
  modules,
  ...
}:

let
  lib = import ../../lib inputs;

in
{
  "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
    pkgs = lib.mkPkgs system;

    modules = [
      {
        home = {
          inherit username;

          homeDirectory = if username == "root" then /root else /home/${username};
        };
      }

      ../modules

      neovim-config.homeManagerModules.neovim
    ] ++ modules;
  };
}
