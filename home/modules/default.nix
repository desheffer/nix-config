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
    ./chrome.nix
    ./cli.nix
    ./communication.nix
    ./games.nix
    ./git.nix
    ./gnome.nix
    ./gui.nix
    ./home.nix
    ./kitty.nix
    ./libreoffice.nix
    ./music.nix
    ./neovim.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
