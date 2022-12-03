{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.fileSystems;

  mapperPrimary = "/dev/mapper/primary";

in
{
  options.modules.fileSystems = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the file systems configuration.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.luks.devices.primary.device = "/dev/disk/by-label/luks_primary";

    fileSystems = {
      "/" = {
        device = mapperPrimary;
        fsType = "btrfs";
        options = [ "subvol=@root" "compress=zstd" ];
      };

      "/nix" = {
        device = mapperPrimary;
        fsType = "btrfs";
        options = [ "subvol=@nix" "compress=zstd" "noatime" ];
      };

      "/persist" = {
        device = mapperPrimary;
        fsType = "btrfs";
        options = [ "subvol=@persist" "compress=zstd" ];
        neededForBoot = true;
      };

      "/swap" = {
        device = mapperPrimary;
        fsType = "btrfs";
        options = [ "subvol=@swap" "noatime" ];
      };

      "/home" = {
        device = mapperPrimary;
        fsType = "btrfs";
        options = [ "subvol=@home" "compress=zstd" ];
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

    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };

    environment.persistence."/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/docker"
        "/var/lib/systemd/coredump"
        "/var/log"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };

    age.identityPaths = [
      "/persist/etc/ssh/ssh_host_ed25519_key"
    ];

    boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
      mkdir -p /mnt
      mount -t btrfs ${mapperPrimary} /mnt

      btrfs subvolume list -o /mnt/@root | cut -d' ' -f9 | while read subvolume; do
        echo "Deleting ''${subvolume} subvolume..."
        btrfs subvolume delete "/mnt/''${subvolume}"
      done

      echo "Deleting @root subvolume..."
      btrfs subvolume delete /mnt/@root

      echo "Restoring blank @root subvolume..."
      btrfs subvolume snapshot /mnt/@root-blank /mnt/@root

      umount /mnt
    '';
  };
}
