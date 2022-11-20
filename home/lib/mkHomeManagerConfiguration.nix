inputs@{ home-manager, neovim-config, ... }:

{ hostname, system, username, modules, ... }:

let
  lib = import ../../lib inputs;

in
{
  "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
    inherit system username;

    pkgs = lib.mkPkgs system;
    homeDirectory = if username == "root" then /root else /home/${username};

    configuration.imports = [
      ../modules

      neovim-config.hmModules.neovim
    ]
    ++ modules;
  };
}
