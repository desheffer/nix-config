{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.disko;

in
{
  options.modules.disko = {
    device = mkOption {
      type = types.str;
      description = "Target disk for the disko partition scheme.";
    };
  };

  config = {
    disko.devices.disk.primary = {
      type = "disk";
      device = cfg.device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "ESP";
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
              extraArgs = [
                "-n"
                "BOOT"
              ];
            };
          };
          primary = {
            label = "primary";
            size = "100%";
            content = {
              type = "luks";
              name = "primary";
              extraFormatArgs = [ "--label=luks_primary" ];
              settings.crypttabExtraOpts = [ "tpm2-device=auto" ];
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "primary"
                ];
                postCreateHook = ''
                  MNT=$(mktemp -d)
                  mount -o subvol=/ /dev/mapper/primary "$MNT"
                  trap 'umount "$MNT"; rm -rf "$MNT"' EXIT
                  btrfs subvolume snapshot -r "$MNT/@root" "$MNT/@root-blank"
                '';
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "compress=zstd" ];
                  };
                  "@swap" = {
                    mountpoint = "/swap";
                    mountOptions = [ "noatime" ];
                    swap.swapfile.size = "16G";
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" ];
                  };
                };
              };
            };
          };
        };
      };
    };

    fileSystems."/persist".neededForBoot = true;
  };
}
