{ config, lib, ... }:

with lib;

let
  cfg = config.modules.agenix;

  secretsManifest = import ../../secrets/manifest.nix;

  filesMapper = name: value: {
    file = ../../secrets/${name};
    owner = value.owner;
  };
  filesMapped = mapAttrs filesMapper secretsManifest.files;

in {
  options.modules.agenix = {
  };

  config = {
    age = {
      secrets = filesMapped;
      secretsDir = secretsManifest.secretsDir;
    };
  };
}
