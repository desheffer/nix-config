with builtins;

let
  secretsManifest = import ./manifest.nix;

  filesMapper = name: value: {
    publicKeys = [ secretsManifest.users.${value.owner} ] ++ (attrValues secretsManifest.systems);
  };
  filesMapped = mapAttrs filesMapper secretsManifest.files;

in
  filesMapped
