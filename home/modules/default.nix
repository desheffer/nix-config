{ lib, ... }:

with lib;

{
  home.stateVersion = mkForce "21.11";

  imports = [
    ./cli.nix
    ./git.nix
    ./gnome.nix
    ./gui.nix
    ./kitty.nix
    ./neovim.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
