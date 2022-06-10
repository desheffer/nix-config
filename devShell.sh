#!/bin/sh
# NOTE: See `shell.nix`. It may be possible to replace this script with a call
# to `nix develop` in the future, but that is not currently feasible.

cd "$(dirname "${0}")"

export NIX_CONFIG='experimental-features = nix-command flakes'
export NIX_PATH='nixpkgs=channel:nixos-22.05'

echo "Creating environment..."

if [ ${#} -ge 1 ] && [ "${1}" = "--home-switch" ]; then
    exec nix-shell --run "nix develop -c @home-switch"
fi

exec nix-shell --command "nix develop"
