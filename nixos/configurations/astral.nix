inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;
  keys = secrets.nixosModules.keys;

in
lib.mkNixosConfiguration {
  hostname = "astral";
  system = "x86_64-linux";
  modules = [
    (
      { pkgs, ... }:
      {
        boot = {
          initrd = {
            availableKernelModules = [
              "nvme"
              "xhci_pci"
              "ahci"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
            kernelModules = [ ];
          };

          kernelModules = [ "kvm-amd" ];
          extraModulePackages = [ ];
        };
      }
    )

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-ssd

    {
      modules.bambu-studio.enable = true;
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.nvidia.enable = true;
      modules.secrets.enable = true;
      modules.virtualbox.enable = true;

      modules.ups = {
        enable = true;
        password = passwords.upsmon;
      };

      modules.deskflow = {
        enableServer = true;
        config = ''
          section: screens
            astral:
            ethereal:
          end

          section: aliases
          end

          section: links
            astral:
              left = ethereal
            ethereal:
              right = astral
          end

          section: options
            clipboardSharing = true
            clipboardSharingSize = 3072
            disableLockToScreen = false
            protocol = barrier
            relativeMouseMoves = false
            switchCornerSize = 0
            switchCorners = none
            win32KeepForeground = false
          end
        '';
        settings = ''
          [core]
          coreMode=2
          lastVersion=1.25.0.0
          screenName=astral
          startedBefore=true

          [gui]
          closeReminder=false
          enableUpdateCheck=false
          logExpanded=true
          windowGeometry=@Rect(0 0 732 500)

          [internalConfig]
          clipboardSharing=true
          clipboardSharingSize=@Variant(\0\0\0\x84\0\0\0\0\0\0\f\0)
          disableLockToScreen=false
          hasHeartbeat=false
          hasSwitchDelay=false
          hasSwitchDoubleTap=false
          heartbeat=5000
          hotkeys\size=0
          numColumns=5
          numRows=3
          protocol=1
          relativeMouseMoves=false
          screens\1\name=
          screens\10\name=
          screens\11\name=
          screens\12\name=
          screens\13\name=
          screens\14\name=
          screens\15\name=
          screens\2\name=
          screens\3\name=
          screens\4\name=
          screens\5\name=
          screens\6\name=
          screens\7\aliasArray\size=0
          screens\7\fixArray\1\fix=false
          screens\7\fixArray\2\fix=false
          screens\7\fixArray\3\fix=false
          screens\7\fixArray\4\fix=false
          screens\7\fixArray\size=4
          screens\7\modifierArray\1\modifier=0
          screens\7\modifierArray\2\modifier=1
          screens\7\modifierArray\3\modifier=2
          screens\7\modifierArray\4\modifier=3
          screens\7\modifierArray\5\modifier=4
          screens\7\modifierArray\6\modifier=5
          screens\7\modifierArray\size=6
          screens\7\name=ethereal
          screens\7\switchCornerArray\1\switchCorner=false
          screens\7\switchCornerArray\2\switchCorner=false
          screens\7\switchCornerArray\3\switchCorner=false
          screens\7\switchCornerArray\4\switchCorner=false
          screens\7\switchCornerArray\size=4
          screens\7\switchCornerSize=0
          screens\8\aliasArray\size=0
          screens\8\fixArray\1\fix=false
          screens\8\fixArray\2\fix=false
          screens\8\fixArray\3\fix=false
          screens\8\fixArray\4\fix=false
          screens\8\fixArray\size=4
          screens\8\modifierArray\1\modifier=0
          screens\8\modifierArray\2\modifier=1
          screens\8\modifierArray\3\modifier=2
          screens\8\modifierArray\4\modifier=3
          screens\8\modifierArray\5\modifier=4
          screens\8\modifierArray\6\modifier=5
          screens\8\modifierArray\size=6
          screens\8\name=astral
          screens\8\switchCornerArray\1\switchCorner=false
          screens\8\switchCornerArray\2\switchCorner=false
          screens\8\switchCornerArray\3\switchCorner=false
          screens\8\switchCornerArray\4\switchCorner=false
          screens\8\switchCornerArray\size=4
          screens\8\switchCornerSize=0
          screens\9\name=
          screens\size=15
          switchCornerArray\1\switchCorner=false
          switchCornerArray\2\switchCorner=false
          switchCornerArray\3\switchCorner=false
          switchCornerArray\4\switchCorner=false
          switchCornerArray\size=4
          switchCornerSize=0
          switchDelay=250
          switchDoubleTap=250
          win32KeepForeground=false

          [server]
          configVisible=false
        '';
      };

      # BUG: NetworkManager-wait-online.service can prevent nixos-rebuild
      # switch from succeeding.
      # See https://github.com/NixOS/nixpkgs/issues/180175
      systemd.services.NetworkManager-wait-online.enable = false;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      extraGroups = [
        "dialout"
        "docker"
        "networkmanager"
        "wheel"
      ];
      modules = [
        {
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.secrets.enable = true;
        }
      ];
      authorizedKeys = [ keys.users.desheffer ];
    })
  ];
}
