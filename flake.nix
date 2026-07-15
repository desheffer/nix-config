{
  description = "Doug's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    flake-utils.url = "github:numtide/flake-utils";

    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-config.url = "github:desheffer/neovim-config";

    llm-agents.url = "github:numtide/llm-agents.nix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
