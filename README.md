# Nix config

This repository contains a Nix flake that can be used to manage entire NixOS
systems and/or Home Manager profiles of individual users.

## 🏃 Quick start

It is possible to run the home configuration in Docker. This can be useful for
demonstration purposes since it makes no changes to the host system.

To start a container and activate the home configuration:

```sh
docker run -it --rm nixpkgs/nix bash -c "
    git clone https://github.com/desheffer/nix-config.git ~/nix-config &&
    ~/nix-config/devShell.sh --home-switch &&
    ~/.nix-profile/bin/zsh"
```

## 🔨 Installation scenarios

### Installing with NixOS (including a fresh install)

Refer to the [Installation][nixos-installation] chapter of the NixOS Manual for
detailed installation instructions. Below is a quick summary.

Boot the NixOS installation environment.

Become root:

```sh
sudo -i
```

Create the partition schema (run `lsblk` to list block devices and replace
`/dev/sda` with the target disk):

```sh
parted -s /dev/sda mklabel gpt

parted -s /dev/sda mkpart ESP fat32 1MiB 512MiB
parted -s /dev/sda set 1 esp on

parted -s /dev/sda mkpart primary linux-swap 512MiB 8GiB

parted -s /dev/sda mkpart primary 8GiB 100%

parted -s /dev/sda print
```

Format the partitions:

```sh
mkfs.fat -F 32 -n boot /dev/sda1

mkswap -L swap /dev/sda2

mkfs.ext4 -L nixos /dev/sda3
```

Mount the partitions:

```sh
mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

swapon /dev/disk/by-label/swap
```

Clone this repository:

```sh
mkdir -p /mnt/etc
cd /mnt/etc

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

Set a root password when prompted.

Reboot into the new system:

```sh
reboot
```

Finally, it may be helpful to change ownership of the configuration directory:

```sh
sudo chown -R ${USER}: /etc/nix-config
sudo git config --global --add safe.directory /etc/nix-config
```

### Installing with Home Manager on a non-NixOS system

Install the Nix package manager, either through a system package manager or
using the [Nix installation script][nix-download]:

```sh
sh <(curl -L https://nixos.org/nix/install)
```

You may be instructed to log out and log back in.

Clone this repository:

```sh
git clone https://github.com/desheffer/nix-config
cd nix-config
```

Build and activate the home configuration (`USER` and `SYSTEM` must be
specified in `homeConfigurations`):

```sh
./devShell.sh --home-switch
```

Run Zsh via the newly installed home configuration:

```sh
~/.nix-profile/bin/zsh
```

If everything works as expected, set Zsh via Nix as the default shell:

```sh
sudo chsh -s ~/.nix-profile/bin/zsh ${USER}
```

### Installing with Home Manager in a non-NixOS Docker container

#### `ubuntu:22.04`

```sh
apt-get update && apt-get install -y curl git sudo xz-utils

useradd -mU desheffer
echo "desheffer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-desheffer

sudo -u desheffer -i bash -c "
    sh <(curl -L https://nixos.org/nix/install) &&
    . ~/.nix-profile/etc/profile.d/nix.sh &&
    git clone https://github.com/desheffer/nix-config ~/nix-config &&
    ~/nix-config/devShell.sh --home-switch &&
    ~/.nix-profile/bin/zsh"
```

## 📚 Resources

- [NixOS configuration options][nixos-options]
- [Home Manager configuration options][home-manager-options]
- [Nix expressions][nix-expressions]

[home-manager-options]: https://nix-community.github.io/home-manager/options.html
[nix-download]: https://nixos.org/download.html
[nix-expressions]: https://nixos.org/manual/nix/stable/expressions/expression-language.html
[nixos-installation]: https://nixos.org/manual/nixos/stable/index.html#ch-installation
[nixos-options]: https://search.nixos.org/options
