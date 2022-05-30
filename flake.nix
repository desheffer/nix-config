{
  description = "Doug's Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, flake-utils, home-manager, devshell, ... }:
    let
      lib = import ./lib inputs;

      systems = flake-utils.lib.system;
    in {
      # NixOS with Home Manager:
      nixosConfigurations =
        # NixOS virtual machine:
        lib.mkNixosConfiguration {
          hostname = "nixos";
          system = systems.x86_64-linux;
          roles = {
            gnome = true;
          };
          modules = [
            ./hardware/nixos.nix
            (lib.mkNixosUserConfiguration {
              username = "desheffer";
              roles = {
                cli = true;
                gnome = true;
              };
              hashedPassword = nixpkgs.lib.fileContents ./secrets/hashedPassword;
              extraGroups = [ "wheel" "vboxsf" ];
            })
          ];
        }
        ;

      # Home Manager for non-NixOS systems:
      homeConfigurations =
        lib.mkHomeManagerConfiguration rec {
          hostname = system;
          system = systems.x86_64-linux;
          username = "root";
          roles = {
            cli = true;
          };
        }
        //
        lib.mkHomeManagerConfiguration rec {
          hostname = system;
          system = systems.x86_64-linux;
          username = "desheffer";
          roles = {
            cli = true;
          };
        }
        ;

      devShell = flake-utils.lib.eachDefaultSystemMap (system: lib.mkDevShell system);
    };
}
