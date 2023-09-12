# Installing with NixOS

Refer to the [Installation][nixos-installation] chapter of the NixOS Manual for
detailed installation instructions. Below is a quick summary.

Boot the NixOS installation environment.

Use `curl https://github.com/desheffer.keys > ~/.ssh/authorized_keys` to copy
SSH authorized keys.

Connect over SSH from an existing, already authenticated machine. Use `ssh -A`
to enable ssh-agent forwarding for accessing secrets later on.

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
btrfs subvolume snapshot -r /mnt/@root /mnt/@root-blank

btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@persist
btrfs subvolume create /mnt/@swap
btrfs subvolume create /mnt/@home

umount /mnt
```

Mount the partitions and subvolumes:

```sh
mount -t btrfs -o subvol=@root,compress=zstd /dev/mapper/primary /mnt

mkdir -p /mnt/nix
mount -t btrfs -o subvol=@nix,compress=zstd,noatime /dev/mapper/primary /mnt/nix

mkdir -p /mnt/persist
mount -t btrfs -o subvol=@persist,compress=zstd /dev/mapper/primary /mnt/persist

mkdir -p /mnt/swap
mount -t btrfs -o subvol=@swap,noatime /dev/mapper/primary /mnt/swap

mkdir -p /mnt/home
mount -t btrfs -o subvol=@home,compress=zstd /dev/mapper/primary /mnt/home

mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

Create a swapfile (set `SIZE` to the desired size):

```sh
SIZE=16GB

truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
head -c ${SIZE} /dev/zero > /mnt/swap/swapfile
chmod 0600 /mnt/swap/swapfile
mkswap /mnt/swap/swapfile

swapon /mnt/swap/swapfile
```

Generate an SSH key to use for managing secrets:

```sh
mkdir -p /mnt/persist/etc/ssh
ssh-keygen -t ed25519 -f /mnt/persist/etc/ssh/ssh_host_ed25519_key -N ""

cat /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
```

Optionally, view the hardware configuration for the new machine:

```sh
nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix
```

On the existing machine: Clone the `desheffer/nix-config` repository. Create a
new `BRANCH`. Create a configuration for the new machine and assign it a
`HOSTNAME`. Use the hardware configuration from the previous step, as needed.

On the existing machine: Clone the `desheffer/secrets` repository. Add the key
from the previous step. Follow the instructions in that repository to rekey
secrets. Commit the changes and push.

On the existing machine: Back in the `desheffer/nix-config` repository, pull in
the changes using `nix flake lock --update-input secrets`. Commit the changes
and push.

Run the install (replace `BRANCH` and `HOSTNAME` using the values from above):

```sh
nixos-install --flake github:desheffer/nix-config/BRANCH#HOSTNAME
```

Reboot when the installation is finished:

```sh
reboot
```

Clone this repository to a more permanent location:

```sh
cd ~/Code

git clone git@github.com:desheffer/nix-config.git
```

[nixos-installation]: https://nixos.org/manual/nixos/stable/index.html#ch-installation
