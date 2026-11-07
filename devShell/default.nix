inputs@{
  nixpkgs,
  flake-utils,
  devshell,
  ...
}:

let
  mkDevShell = (
    system:
    let
      pkgs = import nixpkgs {
        inherit system;

        overlays = [ devshell.overlays.default ];
      };

    in
    pkgs.devshell.mkShell {
      name = "nix-config";

      bash.extra = ''
        export NIX_CONFIG='experimental-features = nix-command flakes'
      '';

      packages = with pkgs; [
        git
        jq
        nh
      ];

      # NOTE: Use ''$ to escape $ in variable names.
      commands = [
        {
          category = "home-manager";
          name = "@home-switch";
          help = "builds and switches to a new home configuration";
          command = ''
            if command -v nixos-rebuild &> /dev/null; then
              read -p "This appears to be a NixOS system. Are you sure you want to configure Home Manager separately? [y/N] " -n 1 -r
              echo
              if [[ ! ''${REPLY} =~ [Yy] ]]; then
                exit 1
              fi
            fi

            export USER=$(whoami)
            echo "USER: ''${USER}"

            SYSTEM=$(nix config show --json | jq -r '.system.value')
            echo "SYSTEM: ''${SYSTEM}"

            nh home switch . -c "''${USER}@''${SYSTEM}"
          '';
        }
        {
          category = "nix";
          name = "@clean";
          help = "collects garbage by removing old generations and unreachable paths";
          command = ''
            nh clean all
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
            nh os boot .
          '';
        }
        {
          category = "nixos";
          name = "@dry-build";
          help = "dry-builds a new system configuration";
          command = ''
            nh os build --dry .
          '';
        }
        {
          category = "nixos";
          name = "@switch";
          help = "builds and activates a new system configuration and makes it the boot default";
          command = ''
            nh os switch .
          '';
        }
      ];
    }
  );

in
flake-utils.lib.eachDefaultSystemMap (system: {
  default = mkDevShell system;
})
