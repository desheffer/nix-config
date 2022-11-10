inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;
  keys = secrets.nixosModules.keys;

in
lib.mkNixosConfiguration {
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
      modules.gnome.enable = true;
      modules.hidpi.enable = true;
      modules.secrets.enable = true;
      modules.ups.enable = true;

      modules.barrier = {
        enable = true;
        config = ''
          section: screens
            astral:
            ethereal:
          end

          section: aliases
          end

          section: links
            astral:
              left = ethereal
            ethereal:
              right = astral
          end
        '';
      };

      modules.docker = {
        enable = true;
        enableNvidia = true;
      };
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      extraGroups = [ "docker" "wheel" ];
      modules = [
        {
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.hidpi.enable = true;
          modules.secrets.enable = true;
        }
      ];
      authorizedKeys = [
        keys.users.desheffer
      ];
    })
  ];
}
