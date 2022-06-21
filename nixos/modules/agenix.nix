{ config, lib, ... }:

with lib;

let
  secretsManifest = import ../../secrets/manifest.nix;

  filesMapper = name: value: {
    file = ../../secrets/${name};
    owner = value.owner;
  };
  filesMapped = mapAttrs filesMapper secretsManifest.files;

in {
  config = {
    age = {
      secrets = filesMapped;
      secretsDir = secretsManifest.secretsDir;
    };
  };
}
