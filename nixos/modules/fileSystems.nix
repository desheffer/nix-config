{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.fileSystems;

in
{
  options.modules.fileSystems = {
    ephemeralRoot = mkOption {
      type = types.bool;
      description = "Enable ephemeral root storage.";
      default = true;
    };
  };

  config = {
    boot.initrd.luks.devices.primary.device = "/dev/disk/by-label/luks_primary";

    fileSystems = {
      "/" = if cfg.ephemeralRoot then {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [ "defaults" "size=2G" "mode=755" ];
        neededForBoot = true;
      } else {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@root" "compress=zstd" ];
        neededForBoot = true;
      };

      "/nix" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@nix" "compress=zstd" "noatime" ];
        neededForBoot = true;
      };

      "/nix/persist" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@root" "compress=zstd" ];
        neededForBoot = true;
        depends = [ "/nix" ];
      };

      "/swap" = {
        device = "/dev/mapper/primary";
        fsType = "btrfs";
        options = [ "subvol=@swap" "noatime" ];
        neededForBoot = true;
      };

      "/home" = {
        device = "/dev/mapper/primary";
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

    environment.persistence."/nix/persist" = mkIf cfg.ephemeralRoot {
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

    age.identityPaths = optionals cfg.ephemeralRoot [
      "/nix/persist/etc/ssh/ssh_host_ed25519_key"
    ];

    systemd.generators = mkIf cfg.ephemeralRoot {
      systemd-gpt-auto-generator = "/dev/null";
    };
  };
}
