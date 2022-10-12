with builtins;

let
  keys = import ./keys.nix;
  secretsManifest = import ./manifest.nix;

  filesMapper = name: value: {
    publicKeys = [ keys.users.${value.owner} ] ++ (attrValues keys.systems);
  };
  filesMapped = mapAttrs filesMapper secretsManifest.files;

in
  filesMapped
