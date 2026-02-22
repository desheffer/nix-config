{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  home.stateVersion = mkForce "21.11";

  imports = [
    ./ai.nix
    ./chrome.nix
    ./cli.nix
    ./communication.nix
    ./git.nix
    ./ghostty.nix
    ./gnome.nix
    ./gui.nix
    ./home.nix
    ./libreoffice.nix
    ./music.nix
    ./neovim.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
