inputs@{ nixpkgs, nixos-hardware, ... }:

let
  lib = import ../../lib inputs;

in lib.mkNixosConfiguration {
  hostname = "nixos-vm";
  system = "x86_64-linux";

  nixosConfig = { };

  extraModules = [
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

    nixos-hardware.nixosModules.common-cpu-intel
    {
      virtualisation.virtualbox.guest.enable = true;
    }

    ({ config, ... }: lib.mkNixosUserConfiguration {
      username = "desheffer";
      passwordFile = config.age.secrets.deshefferPassword.path;
      extraGroups = [ "vboxsf" "wheel" ];

      homeConfig = {
        cli.enable = true;
      };
    })
  ];
}
