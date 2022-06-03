inputs@{ home-manager, ... }:

{ hostname, system, username, homeConfig, ... }:

let
  lib = import ../../lib inputs;

in {
  "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
    inherit system username;

    pkgs = lib.mkPkgs system;
    homeDirectory = if username == "root" then /root else /home/${username};
    configuration.imports = [
      {
        config.homeConfig = homeConfig;
      }
      ../modules
    ];
  };
}
