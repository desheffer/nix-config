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
    ./hidpi.nix
    ./kitty.nix
    ./neovim.nix
    ./slack.nix
    ./spotify.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
