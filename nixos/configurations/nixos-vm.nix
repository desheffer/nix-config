inputs@{ nixpkgs, nixos-hardware, ... }:

let
  lib = import ../../lib inputs;

in lib.mkNixosConfiguration {
  hostname = "nixos-vm";
  system = "x86_64-linux";

  nixosConfig = {
    gnome.enable = true;
  };

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

    {
      security.sudo.wheelNeedsPassword = false;

      services.xserver.displayManager.autoLogin = {
        enable = true;
        user = "desheffer";
      };
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      hashedPassword = nixpkgs.lib.fileContents ../../secrets/hashedPassword;
      extraGroups = [ "wheel" "vboxsf" ];

      homeConfig = {
        cli.enable = true;
        gnome.enable = true;
      };
    })
  ];
}