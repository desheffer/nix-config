{ config, lib, ... }:

with lib;

{
  home.stateVersion = mkForce "21.11";

  imports = [
    ./neovim

    ./agenix.nix
    ./chrome.nix
    ./cli.nix
    ./discord.nix
    ./git.nix
    ./gnome.nix
    ./gui.nix
    ./hidpi.nix
    ./home.nix
    ./kitty.nix
    ./slack.nix
    ./spotify.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
