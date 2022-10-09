inputs@{ nixos-hardware, ... }:

let
  lib = import ../../lib inputs;

in lib.mkNixosConfiguration {
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
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.hidpi.enable = true;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialPassword = "nix";
      extraGroups = [ "docker" "wheel" ];
      modules = [
        {
          modules.agenix.enable = true;
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.hidpi.enable = true;
        }
      ];
    })
  ];
}
