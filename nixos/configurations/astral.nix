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
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux.override {
          argsOverride = rec {
            src = pkgs.fetchurl {
              url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
              sha256 = "sha256-yTuzhKl60fCk8Y5ELOApEkJyL3gCPspliyI0RUHwlIk=";
            };
            version = "5.19.17";
            modDirVersion = "5.19.17";
          };
        });

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
      modules.virtualbox.enable = true;

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
      extraGroups = [ "docker" "networkmanager" "wheel" ];
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
