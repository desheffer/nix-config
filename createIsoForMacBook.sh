#!/bin/bash

set -e

[ -d nixpkgs ] || git clone --depth 1 https://github.com/NixOS/nixpkgs.git

cp installation-cd-graphical-gnome-macbook.nix nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome-macbook.nix

docker run -it --rm \
    -v "${PWD}":/pwd \
    -w /pwd/nixpkgs/nixos \
    nixos/nix \
    bash -c "
        export NIXPKGS_ALLOW_UNFREE=1 &&
        nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/installation-cd-graphical-gnome-macbook.nix default.nix &&
        cp result/iso/* /pwd"
