{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.fileSystems;

  mapperPrimary = "/dev/mapper/primary";

in
{
  options.modules.fileSystems = { };

  config = {
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };

    systemd.services.btrfs-balance = {
      description = "Btrfs data balance";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=50 /";
        IOSchedulingClass = "idle";
      };
    };

    systemd.timers.btrfs-balance = {
      description = "Weekly btrfs data balance";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Sat *-*-* 06:30:00 US/Eastern";
        Persistent = true;
      };
    };

    environment.persistence."/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/docker"
        "/var/lib/iwd"
        "/var/lib/nixos"
        "/var/lib/sbctl"
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

    age.identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

    # Wipe the @root subvolume on every boot ("erase your darlings"). Under
    # systemd stage 1 this runs as a service ordered after the LUKS device is
    # opened and before the root filesystem is mounted.
    boot.initrd.systemd.services.rollback-root = {
      description = "Rollback @root btrfs subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@primary.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
        mount -t btrfs ${mapperPrimary} /mnt

        btrfs subvolume list -o /mnt/@root | cut -d' ' -f9 | while read subvolume; do
          echo "Deleting $subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done

        echo "Deleting @root subvolume..."
        btrfs subvolume delete /mnt/@root

        echo "Restoring blank @root subvolume..."
        btrfs subvolume snapshot /mnt/@root-blank /mnt/@root

        umount /mnt
      '';
    };
  };
}
