{ lib, ... }:

with lib;

{
  home.stateVersion = mkForce "21.11";

  imports = [
    ./chrome.nix
    ./cli.nix
    ./git.nix
    ./gnome.nix
    ./gui.nix
    ./kitty.nix
    ./neovim.nix
    ./spotify.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
