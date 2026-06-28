inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;
  keys = secrets.nixosModules.keys;

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
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.printing.enable = true;
      modules.secrets.enable = true;

      modules.disko.device = "/dev/disk/by-id/nvme-PM981_NVMe_Samsung_512GB__S3ZHNY0K826714";
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      avatar = "headphones.jpg";
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
