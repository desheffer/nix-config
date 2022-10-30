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

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-custom.url = "github:desheffer/neovim-flake";
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
