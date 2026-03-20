inputs@{
  nixpkgs,
  nixpkgs-unstable,
  llm-agents,
  ...
}:

{
  system,
  permittedInsecurePackages ? [ ],
  ...
}:

let
  pkgs = import nixpkgs { inherit system config overlays; };

  pkgs-unstable = import nixpkgs-unstable { inherit system config; };

  config = {
    inherit permittedInsecurePackages;

    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      # Example: some-pkg = pkgs-unstable.some.pkg;
      claude-code = llm-agents.packages.${system}.claude-code;
      opencode = llm-agents.packages.${system}.opencode;
    })
  ];

in
pkgs
