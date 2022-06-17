inputs@{ nixpkgs, nixos-hardware, ... }:

let
  lib = import ../../lib inputs;

in lib.mkNixosConfiguration {
  hostname = "argent";
  system = "x86_64-linux";

  nixosConfig = {
    docker.enable = true;
    gnome.enable = true;
    hidpi.enable = true;
  };

  extraModules = [
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

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialPassword = "nix";
      extraGroups = [ "docker" "wheel" ];

      homeConfig = {
        cli.enable = true;
        gnome.enable = true;
        hidpi.enable = true;
      };
    })
  ];
}
