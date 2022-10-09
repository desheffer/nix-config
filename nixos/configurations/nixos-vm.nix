inputs@{ nixos-hardware, ... }:

let
  lib = import ../../lib inputs;

in lib.mkNixosConfiguration {
  hostname = "nixos-vm";
  system = "x86_64-linux";
  modules = [
    {
      boot = {
        initrd = {
          availableKernelModules = [ "ata_piix" "ohci_pci" "ahci" "sd_mod" "sr_mod" ];
          kernelModules = [ ];
        };

        kernelModules = [ ];
        extraModulePackages = [ ];
      };
    }

    # nixos-hardware.nixosModules.common-cpu-amd
    # nixos-hardware.nixosModules.common-cpu-intel
    {
      virtualisation.virtualbox.guest.enable = true;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialPassword = "nix";
      extraGroups = [ "vboxsf" "wheel" ];
      modules = [
        {
          modules.agenix.enable = true;
          modules.cli.enable = true;
        }
      ];
    })
  ];
}
