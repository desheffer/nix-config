# Installing with NixOS

Refer to the [Installation][nixos-installation] chapter of the NixOS Manual for
detailed installation instructions. Below is a quick summary.

Boot the NixOS installation environment. Connect over SSH, if possible.

Become root:

```sh
sudo -i
```

Create the partition schema (run `lsblk` to list block devices and replace
`/dev/nvme0n1` with the target disk):

```sh
TARGET=/dev/nvme0n1
BOOT=/dev/nvme0n1p1
PRIMARY=/dev/nvme0n1p2

parted -s ${TARGET} mklabel gpt

parted -s ${TARGET} mkpart ESP fat32 0% 512MiB
parted -s ${TARGET} set 1 esp on

parted -s ${TARGET} mkpart primary 512MiB 100%

parted -s ${TARGET} print
```

Format the boot partition:

```sh
mkfs.fat -F 32 -n BOOT ${BOOT}
```

Format the primary partition (set `PASSWORD` to the desired password):

```sh
PASSWORD="password"

echo "${PASSWORD}" | cryptsetup -q --label=luks_primary luksFormat ${PRIMARY}
echo "${PASSWORD}" | cryptsetup luksOpen ${PRIMARY} primary

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

Generate an SSH key to use for managing secrets:

```sh
mkdir -p /mnt/etc/ssh
ssh-keygen -t ed25519 -f /mnt/etc/ssh/ssh_host_ed25519_key -N ""

cat /mnt/etc/ssh/ssh_host_ed25519_key.pub
```

On another, already authenticated machine:
- Create a new Git branch.
- In the `nixos/configurations` directory, create a configuration for the new
  machine.
- Open the `secrets` directory, add the public key from the previous step to
  `keys.nix`, and rekey secrets by running `agenix --rekey`.
- Commit and push.
- Return to the new machine.

Open a Nix shell with Git:

```sh
nix-shell -p git
```

Clone this repository:

```sh
git clone https://github.com/desheffer/nix-config /mnt/etc/nix-config
cd /mnt/etc/nix-config
```

Checkout the Git branch from above.

Open a development shell:

```sh
export NIX_CONFIG='experimental-features = nix-command flakes'
nix develop
```

Run the installation (replace `HOSTNAME`):

```sh
@install HOSTNAME
```

Reboot when the installation is finished:

```sh
reboot
```

Be sure to change all default user passwords.

Change ownership of the new configuration directory (as a non-root user):

```sh
sudo chown -R ${USER}: /etc/nix-config
sudo git config --global --add safe.directory /etc/nix-config
```

[nixos-installation]: https://nixos.org/manual/nixos/stable/index.html#ch-installation
