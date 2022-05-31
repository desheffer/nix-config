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

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    boot.initrd.luks.devices.luks.device = "/dev/disk/by-label/luks_root";

    fileSystems."/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

    virtualisation.virtualbox.guest.enable = true;

    security.sudo.wheelNeedsPassword = false;

    services.xserver.displayManager.autoLogin = {
      enable = true;
      user = "desheffer";
    };
  }
