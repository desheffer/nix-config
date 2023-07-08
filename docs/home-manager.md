# Installing with Home Manager on a non-NixOS system

Install the Nix package manager, either through a system package manager or
using the [Determinate Nix Installer][nix-installer].

Clone this repository:

```sh
git clone https://github.com/desheffer/nix-config
cd nix-config
```

Build and activate the home configuration (the current `USER` and `SYSTEM` will
be detected, and they must match pre-existing values in `homeConfigurations`):

```sh
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

[nix-installer]: https://github.com/DeterminateSystems/nix-installer
