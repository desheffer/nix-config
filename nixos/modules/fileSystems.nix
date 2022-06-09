{ config, lib, ... }:

with lib;

{
  config = {
    boot.initrd.luks.devices.primary.device = "/dev/disk/by-label/luks_primary";

    fileSystems = {
      "/" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@root" "compress=zstd" ];
      };

      "/home" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@home" "compress=zstd" ];
      };

      "/nix" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@nix" "compress=zstd" "noatime" ];
      };

      "/swap" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@swap" "noatime" ];
      };

      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };
    };

    swapDevices = [
      {
        device = "/swap/swapfile";
      }
    ];
  };
}
