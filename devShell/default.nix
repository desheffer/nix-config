inputs@{ nixpkgs, flake-utils, devshell, agenix, ... }:

let
  mkDevShell = (system:
    let
      pkgs = import nixpkgs {
        inherit system;

        overlays = [ devshell.overlay ];
      };

    in pkgs.devshell.mkShell {
      name = "nix-config";

      bash.extra = ''
        export NIX_CONFIG='experimental-features = nix-command flakes'
      '';

      packages = with pkgs; [
        agenix.defaultPackage.${system}
        git
        jq
      ];

      # NOTE: Use ''$ to escape $ in variable names.
      commands = [
        {
          category = "agenix";
          name = "@agenix-encrypt";
          help = "encrypts stdin to a file";
          command = ''
            if [ ''${#} -lt 1 ]; then
              echo "Usage: @agenix-encrypt OUTPUT" > /dev/stderr
              exit 1
            fi

            EDITOR='cp /dev/stdin' agenix --edit "''${1}"
          '';
        }
        {
          category = "agenix";
          name = "@agenix-rekey";
          help = "re-encrypts all secrets";
          command = ''
            agenix --rekey
          '';
        }
        {
          category = "home-manager";
          name = "@home-switch";
          help = "builds and switches to a new home configuration";
          command = ''
            export USER=$(whoami)
            echo "USER: ''${USER}"

            SYSTEM=$(nix show-config --json | jq -r '.system.value')
            echo "SYSTEM: ''${SYSTEM}"

            nix run .#homeConfigurations."''${USER}@''${SYSTEM}".activationPackage
          '';
        }
        {
          category = "nix";
          name = "@clean";
          help = "collects garbage by removing old generations and unreachable paths";
          command = ''
            nix-collect-garbage -d
          '';
        }
        {
          category = "nix";
          name = "@update";
          help = "updates the flake lock file";
          command = ''
            nix flake update
          '';
        }
        {
          category = "nixos";
          name = "@boot";
          help = "builds a new system configuration and makes it the boot default";
          command = ''
            nixos-rebuild boot --flake .#
          '';
        }
        {
          category = "nixos";
          name = "@dry-build";
          help = "dry-builds a new system configuration";
          command = ''
            nixos-rebuild dry-build --flake .#
          '';
        }
        {
          category = "nixos";
          name = "@install";
          help = "installs a new system";
          command = ''
            if [ ''${#} -lt 1 ]; then
              echo "Usage: @install HOSTNAME" > /dev/stderr
              exit 1
            fi

            nixos-install --flake .#"''${1}" --impure
          '';
        }
        {
          category = "nixos";
          name = "@switch";
          help = "builds and activates a new system configuration and makes it the boot default";
          command = ''
            nixos-rebuild switch --flake .#
          '';
        }
      ];
    }
  );

in
  flake-utils.lib.eachDefaultSystemMap mkDevShell
