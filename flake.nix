{
  description = "Doug's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    impermanence.url = "github:nix-community/impermanence";

    devshell.url = "github:numtide/devshell";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    neovim-config.url = "github:desheffer/neovim-config";

    secrets.url = "git+ssh://git@github.com/desheffer/secrets?ref=main";
  };

  outputs = inputs: {
    # NixOS with Home Manager:
    nixosConfigurations = import ./nixos/configurations inputs;

    # Home Manager for non-NixOS systems:
    homeConfigurations = import ./home/configurations inputs;

    # Shell provided by `nix develop`:
    devShell = import ./devShell inputs;

    # Formatter provided by `nix fmt`:
    formatter = import ./formatter inputs;
  };
}
