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

- [Installing with NixOS](/docs/nixos.md)
- [Installing with Home Manager on a non-NixOS system](/docs/home-manager.md)

## 📚 Resources

- [NixOS configuration options][nixos-options]
- [Home Manager configuration options][home-manager-options]
- [Nix expressions][nix-expressions]

[home-manager-options]: https://nix-community.github.io/home-manager/options.html
[nix-expressions]: https://nixos.org/manual/nix/stable/expressions/expression-language.html
[nixos-options]: https://search.nixos.org/options
