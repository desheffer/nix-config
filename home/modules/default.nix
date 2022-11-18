{ config, lib, pkgs, ... }:

with lib;

{
  home.stateVersion = mkForce "21.11";

  imports = [
    ./chrome.nix
    ./cli.nix
    ./discord.nix
    ./git.nix
    ./gnome.nix
    ./gui.nix
    ./hidpi.nix
    ./home.nix
    ./kitty.nix
    ./neovim.nix
    ./secrets.nix
    ./slack.nix
    ./spotify.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
