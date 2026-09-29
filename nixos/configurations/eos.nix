inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;
  keys = secrets.nixosModules.keys;

  pkgs-linux-7-1 =
    import
      (builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/0a93637388adbaeed82e91096d034f4ffbf32428.tar.gz";
        sha256 = "0iwx3zyqfxwk9a5xqfzrblzpsfhr3r11g2lgmhszg0qjxlk2k8d8";
      })
      {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

in
lib.mkNixosConfiguration {
  hostname = "eos";
  system = "x86_64-linux";
  modules = [
    (
      { pkgs, ... }:
      {
        boot = {
          kernelPackages = pkgs-linux-7-1.linuxPackages_7_1;

          initrd = {
            availableKernelModules = [
              "nvme"
              "xhci_pci"
              "thunderbolt"
              "usb_storage"
              "usbhid"
              "sd_mod"
            ];
            kernelModules = [ ];
          };

          kernelModules = [ "kvm-amd" ];
          extraModulePackages = [ ];
        };
      }
    )

    nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia
    {
      hardware.nvidia.prime = {
        amdgpuBusId = "PCI:194:0:0"; # c2:00.0
        nvidiaBusId = "PCI:193:0:0"; # c1:00.0
      };

      networking.networkmanager.wifi = {
        backend = "iwd";
        powersave = false;
      };
    }

    {
      modules.docker.enable = true;
      modules.nvidia.enable = true;
      modules.secrets.enable = true;

      modules.disko.device = "/dev/disk/by-id/nvme-WD_BLACK_SN7100_1TB_254764806766";

      modules.gnome = {
        enable = true;
        gdmScalingFactor = 2;
      };
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
          modules.ai.enable = true;
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.secrets.enable = true;
        }
      ];
      authorizedKeys = [ keys.users.desheffer ];
    })
  ];
}
