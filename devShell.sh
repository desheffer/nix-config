#!/bin/sh

cd "$(dirname "${0}")"

if [ "${PWD}" != /etc/nix-config ]; then
    echo "Error: This script expects to run from /etc/nix-config."
    exit 1
fi

export NIX_CONFIG='experimental-features = nix-command flakes'
export NIX_PATH='nixpkgs=channel:nixos-22.05'

echo "Creating environment..."

if [ ${#} -ge 1 ] && [ "${1}" = "--home-switch" ]; then
    exec nix develop -c @home-switch
fi

exec nix develop
