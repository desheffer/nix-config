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

Identify the target disk:

```sh
ls -l /dev/disk/by-id/
```

(On the existing machine) Clone the `desheffer/nix-config` repository. Create a
new `BRANCH`. Create a configuration for the new machine. Assign it a
`HOSTNAME`. Set `modules.disko.device` to the `/dev/disk/by-id/` path from the
previous step. Commit the changes and push.

(On the target machine) Partition and format the disk with disko, using the
configuration just pushed (set `BRANCH` and `HOSTNAME` to match):

```sh
BRANCH="main"
HOSTNAME=""

nix run github:nix-community/disko -- --mode disko --flake github:desheffer/nix-config/${BRANCH}#${HOSTNAME}
```

You will be prompted for the LUKS passphrase during formatting.

Generate an SSH key to use for managing secrets:

```sh
mkdir -p /mnt/persist/etc/ssh
ssh-keygen -t ed25519 -f /mnt/persist/etc/ssh/ssh_host_ed25519_key -N ""

cat /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
```

Optionally, view the hardware configuration for the new machine (for example,
to copy kernel modules into the host configuration):

```sh
nixos-generate-config --root /mnt
cat /mnt/etc/nixos/hardware-configuration.nix
```

(On the existing machine) Clone the `desheffer/secrets` repository. Add the key
from the previous step. Follow the instructions in that repository to rekey
secrets. Commit the changes and push.

(On the existing machine) Back in the `desheffer/nix-config` repository, pull
in the changes using `nix flake lock --update-input secrets`. Commit the
changes and push.

Run the install (reusing `BRANCH` and `HOSTNAME` from above):

```sh
nixos-install --flake github:desheffer/nix-config/${BRANCH}#${HOSTNAME} --no-root-password
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
