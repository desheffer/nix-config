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
      device = "/dev/mapper/vg0-root";
      fsType = "ext4";
    };

    fileSystems."/home" = {
      device = "/dev/mapper/vg0-home";
      fsType = "ext4";
    };

    swapDevices = [
      { device = "/dev/mapper/vg0-swap"; }
    ];
  };
}
