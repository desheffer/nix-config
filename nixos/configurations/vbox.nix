inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;

in
lib.mkNixosConfiguration {
  hostname = "vbox";
  system = "x86_64-linux";
  modules = [
    ({ config, ... }: {
      boot = {
        initrd = {
          availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
          kernelModules = [ ];
        };

        kernelModules = [ ];
        extraModulePackages = [ ];
      };
    })

    {
      virtualisation.virtualbox.guest.enable = true;
    }

    {
      modules.gnome.enable = true;
      modules.secrets.enable = true;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      extraGroups = [ "docker" "wheel" ];
      modules = [
        {
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.secrets.enable = true;
        }
      ];
    })
  ];
}
