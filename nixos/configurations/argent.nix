inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;
  keys = secrets.nixosModules.keys;

in
lib.mkNixosConfiguration {
  hostname = "argent";
  system = "x86_64-linux";
  allowInsecurePredicate = pkg: (builtins.substring 0 13 pkg.name) == "broadcom-sta-";
  modules = [
    (
      { config, ... }:
      {
        boot = {
          initrd = {
            availableKernelModules = [
              "xhci_pci"
              "ahci"
              "usb_storage"
              "usbhid"
              "sd_mod"
            ];
            kernelModules = [ "dm-snapshot" ];
          };

          kernelModules = [
            "kvm-intel"
            "wl"
          ];
          extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

          blacklistedKernelModules = [
            "b43"
            "bcma"
          ];
        };
      }
    )

    nixos-hardware.nixosModules.apple-macbook-pro
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    {
      hardware.facetimehd = {
        enable = true;
        withCalibration = true;
      };
    }

    {
      modules.boot.secureBoot.enable = false;
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.printing.enable = true;
      modules.secrets.enable = true;

      modules.disko.device = "/dev/disk/by-id/ata-APPLE_SSD_SM0256F_S1K4NYBFA48528";
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
