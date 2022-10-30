inputs@{ nixos-hardware, ... }:

let
  lib = import ../../lib inputs;
  keys = import ../../secrets/keys.nix;

in
lib.mkNixosConfiguration {
  hostname = "astral";
  system = "x86_64-linux";
  modules = [
    ({ pkgs, ... }: {
      boot = {
        # Linux >=5.17 is required for wifi functionality.
        kernelPackages = pkgs.linuxPackages_5_19;

        initrd = {
          availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
          kernelModules = [ ];
        };

        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };
    })

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc-ssd
    {
      hardware.nvidia.prime.offload.enable = false;
    }

    {
      modules.gnome.enable = true;
      modules.hidpi.enable = true;
      modules.ups.enable = true;

      modules.docker = {
        enable = true;
        enableNvidia = true;
      };

      modules.barrier = {
        enable = true;
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
        '';
      };
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      extraGroups = [ "docker" "wheel" ];
      modules = [
        {
          modules.agenix.enable = true;
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.hidpi.enable = true;
        }
      ];
      authorizedKeys = [
        keys.users.desheffer
      ];
    })
  ];
}
