inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;

in
lib.mkNixosConfiguration {
  hostname = "ethereal";
  system = "x86_64-linux";
  modules = [
    (
      { config, ... }:
      {
        boot = {
          initrd = {
            availableKernelModules = [
              "xhci_pci"
              "nvme"
              "usb_storage"
              "sd_mod"
              "rtsx_pci_sdmmc"
            ];
            kernelModules = [ ];
          };

          kernelModules = [ "kvm-intel" ];
          extraModulePackages = [ ];
        };
      }
    )

    nixos-hardware.nixosModules.dell-xps-13-9370
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-laptop-ssd

    {
      modules.autoUpgrade.enable = true;
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.printing.enable = true;
      modules.secrets.enable = true;

      modules.barrier = {
        enableClient = true;
        serverAddress = "192.168.1.32";
      };
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      extraGroups = [
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
    })
  ];
}
