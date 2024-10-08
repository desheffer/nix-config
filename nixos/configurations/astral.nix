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
    (
      { pkgs, ... }:
      {
        boot = {
          initrd = {
            availableKernelModules = [
              "nvme"
              "xhci_pci"
              "ahci"
              "usbhid"
              "usb_storage"
              "sd_mod"
            ];
            kernelModules = [ ];
          };

          kernelModules = [ "kvm-amd" ];
          extraModulePackages = [ ];
        };
      }
    )

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-ssd

    {
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.nvidia.enable = true;
      modules.secrets.enable = true;
      modules.virtualbox.enable = true;

      modules.ups = {
        enable = true;
        password = passwords.upsmon;
      };

      modules.barrier = {
        enableServer = true;
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

      # BUG: NetworkManager-wait-online.service can prevent nixos-rebuild
      # switch from succeeding.
      # See https://github.com/NixOS/nixpkgs/issues/180175
      systemd.services.NetworkManager-wait-online.enable = false;
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
      authorizedKeys = [ keys.users.desheffer ];
    })
  ];
}
