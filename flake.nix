{
  description = "Doug's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    impermanence.url = "github:nix-community/impermanence";

    devshell.url = "github:numtide/devshell";

    neovim-custom.url = "github:desheffer/neovim-flake";

    secrets.url = "git+ssh://git@github.com/desheffer/secrets?ref=main";
  };

  outputs = inputs@{ ... }:
    {
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
