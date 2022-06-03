{ config, lib, ... }:

with lib;

{
  config = {
    boot.initrd.luks.devices.luks.device = "/dev/disk/by-label/luks_root";

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

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
  };
}
