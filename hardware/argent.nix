{ config, modulesPath, ... }:
  {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      kernelModules = [ "kvm-intel" "wl" ];
      extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

      initrd = {
        availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        kernelModules = [ "dm-snapshot" ];
      };

      loader = {
        efi.canTouchEfiVariables = true;

        systemd-boot = {
          enable = true;
          consoleMode = "0";
        };
      };

      plymouth.enable = true;
    };

    networking = {
      hostName = "argent";
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
    hardware.video.hidpi.enable = true;

    services.fstrim.enable = true;
  }
