{ config, lib, pkgs, ... }:
  {
    boot = {
      kernelModules = [ ];
      extraModulePackages = [ ];

      initrd = {
        availableKernelModules = [ "ata_piix" "ohci_pci" "ahci" "sd_mod" "sr_mod" ];
        kernelModules = [ ];
      };

      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = true;
      };

      plymouth.enable = true;
    };

    networking = {
      hostName = "nixos-vm";
      useDHCP = false;
      interfaces.enp0s3.useDHCP = true;
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];

    hardware.cpu.intel.updateMicrocode = true;
    virtualisation.virtualbox.guest.enable = true;

    security.sudo.wheelNeedsPassword = false;

    services.xserver.displayManager.autoLogin = {
      enable = true;
      user = "desheffer";
    };
  }
