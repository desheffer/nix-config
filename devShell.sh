#!/bin/sh

cd "$(dirname "${0}")"

export NIX_CONFIG='experimental-features = nix-command flakes'
export NIX_PATH='nixpkgs=channel:nixos-22.05'

echo "Creating environment..."

if [ ${#} -ge 1 ] && [ "${1}" = "--home-switch" ]; then
    exec nix develop -c @home-switch
fi

exec nix develop
