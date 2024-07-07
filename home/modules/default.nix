{ config, lib, pkgs, ... }:

with lib;

{
  home.stateVersion = mkForce "21.11";

  imports = [
    ./chrome.nix
    ./cli.nix
    ./communication.nix
    ./git.nix
    ./gnome.nix
    ./gui.nix
    ./home.nix
    ./kitty.nix
    ./libreoffice.nix
    ./neovim.nix
    ./spotify.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
