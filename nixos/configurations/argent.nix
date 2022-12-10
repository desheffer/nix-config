inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;

in
lib.mkNixosConfiguration {
  hostname = "argent";
  system = "x86_64-linux";
  modules = [
    ({ config, ... }: {
      boot = {
        initrd = {
          availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
          kernelModules = [ "dm-snapshot" ];
        };

        kernelModules = [ "kvm-intel" "wl" ];
        extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
      };
    })

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    {
      services.mbpfan.enable = true;
    }

    {
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.hidpi.enable = true;
      modules.printing.enable = true;
      modules.secrets.enable = true;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      extraGroups = [ "docker" "networkmanager" "wheel" ];
      modules = [
        {
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.hidpi.enable = true;
          modules.secrets.enable = true;
        }
      ];
    })
  ];
}
