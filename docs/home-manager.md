# Installing with Home Manager on a non-NixOS system

Install the Nix package manager, either through a system package manager or
using the [Nix installation script][nix-download]:

```sh
sh <(curl -L https://nixos.org/nix/install)
```

You may be instructed to log out and log back in.

Clone this repository:

```sh
sudo mkdir /etc/nix-config
sudo chown ${USER}: /etc/nix-config

git clone https://github.com/desheffer/nix-config /etc/nix-config
cd /etc/nix-config
```

Build and activate the home configuration (`USER` and `SYSTEM` must be
specified in `homeConfigurations`):

```sh
export NIX_CONFIG='experimental-features = nix-command flakes'
nix develop -c @home-switch
```

Run Zsh via the newly installed home configuration:

```sh
~/.nix-profile/bin/zsh
```

If everything works as expected, set Zsh via Nix as the default shell:

```sh
echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells

chsh -s ~/.nix-profile/bin/zsh
```

[nix-download]: https://nixos.org/download.html
