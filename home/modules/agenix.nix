{ config, lib, ... }:

with lib;

let
  cfg = config.modules.agenix;

  secretsManifest = import ../../secrets/manifest.nix;

  filesFilter = name: value: value.owner == config.home.username;
  filesFiltered = filterAttrs filesFilter secretsManifest.files;

  filesMapper = name: value: nameValuePair value.target {
    source = config.lib.file.mkOutOfStoreSymlink "${secretsManifest.secretsDir}/${name}";
  };
  filesMapped = mapAttrs' filesMapper filesFiltered;

in
{
  options.modules.agenix = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to link agenix secrets.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.file = filesMapped;
  };
}
