inputs@{
  nixpkgs,
  nixpkgs-unstable,
  llm-agents,
  difit-nix,
  ...
}:

{
  system,
  permittedInsecurePackages ? [ ],
  allowInsecurePredicate ? null,
  ...
}:

let
  pkgs = import nixpkgs { inherit system config overlays; };

  pkgs-unstable = import nixpkgs-unstable { inherit system config; };

  config = {
    inherit permittedInsecurePackages allowInsecurePredicate;

    allowUnfree = true;
  };

  overlays = [
    (final: prev: {
      # Example: some-pkg = pkgs-unstable.some.pkg;
      claude-code = llm-agents.packages.${system}.claude-code;
      difit = difit-nix.packages.${system}.difit.override { pnpm_10 = final.pnpm_10_latest; };
      opencode = llm-agents.packages.${system}.opencode;
    })
  ];

in
pkgs
