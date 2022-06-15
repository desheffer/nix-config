# Installing with Home Manager on a non-NixOS system

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

## Installing with Home Manager in a non-NixOS Docker container

### `ubuntu:22.04`

```sh
apt-get update && apt-get install -y curl git sudo xz-utils

useradd -mU desheffer
echo "desheffer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-desheffer

sudo -u desheffer -i bash -c "
    sh <(curl -L https://nixos.org/nix/install) &&
    . ~/.nix-profile/etc/profile.d/nix.sh &&
    git clone https://github.com/desheffer/nix-config /etc/nix-config &&
    /etc/nix-config/devShell.sh --home-switch &&
    ~/.nix-profile/bin/zsh"
```

## Installing with Home Manager in a Docker container to test local changes

```sh
docker run -it --rm \
    -e TERM=xterm-256color \
    -v "${PWD}":/etc/nix-config \
    nixpkgs/nix \
    bash -c "/etc/nix-config/devShell.sh --home-switch && ~/.nix-profile/bin/zsh"
```

[nix-download]: https://nixos.org/download.html
