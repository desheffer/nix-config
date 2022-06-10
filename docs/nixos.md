# Installing with NixOS

Refer to the [Installation][nixos-installation] chapter of the NixOS Manual for
detailed installation instructions. Below is a quick summary.

Boot the NixOS installation environment. Connect over SSH, if possible.

Become root:

```sh
sudo -i
```

Create the partition schema (run `lsblk` to list block devices and replace
`/dev/sda` with the target disk):

```sh
parted -s /dev/sda mklabel gpt

parted -s /dev/sda mkpart ESP fat32 0% 512MiB
parted -s /dev/sda set 1 esp on

parted -s /dev/sda mkpart primary 512MiB 100%

parted -s /dev/sda print
```

Format the boot partition:

```sh
mkfs.fat -F 32 -n BOOT /dev/sda1
```

Format the primary partition (set `PASSWORD` to the desired password):

```sh
PASSWORD="password"

echo "${PASSWORD}" | cryptsetup -q --label=luks_primary luksFormat /dev/sda2
echo "${PASSWORD}" | cryptsetup luksOpen /dev/sda2 primary

mkfs.btrfs -L primary /dev/mapper/primary
```

Create subvolumes in the primary partition:

```sh
mount -t btrfs /dev/mapper/primary /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@swap
umount /mnt
```

Mount the partitions and subvolumes:

```sh
mount -t btrfs -o subvol=@root,compress=zstd /dev/mapper/primary /mnt

mkdir -p /mnt/home
mount -t btrfs -o subvol=@home,compress=zstd /dev/mapper/primary /mnt/home

mkdir -p /mnt/nix
mount -t btrfs -o subvol=@nix,compress=zstd,noatime /dev/mapper/primary /mnt/nix

mkdir -p /mnt/swap
mount -t btrfs -o subvol=@swap,noatime /dev/mapper/primary /mnt/swap

mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

Create a swapfile (set `SIZE` to the desired size in MB):

```sh
SIZE=$(( 16 * 1024 ))

truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
btrfs property set /mnt/swap/swapfile compression none
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=${SIZE}
chmod 0600 /mnt/swap/swapfile
mkswap /mnt/swap/swapfile

swapon /mnt/swap/swapfile
```

Clone this repository:

```sh
mkdir -p /mnt/etc
cd /mnt/etc

nix-env -iA nixos.git
git clone https://github.com/desheffer/nix-config
cd nix-config
```

Open a development shell:

```sh
./devShell.sh
```

Unlock the git-crypt (copy `~/.git-crypt-key` from an external source, if you
are me):

```sh
@unlock
```

Run the installation (`HOSTNAME` must be specified in `nixosConfigurations`):

```sh
@install HOSTNAME
```

Reboot into the new system:

```sh
reboot
```

Finally, it may be helpful to change ownership of the configuration directory:

```sh
sudo chown -R ${USER}: /etc/nix-config
sudo git config --global --add safe.directory /etc/nix-config
```

[nixos-installation]: https://nixos.org/manual/nixos/stable/index.html#ch-installation
