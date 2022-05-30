{ lib, ... }:
  {
    home.stateVersion = lib.mkForce "21.11";

    imports = [
      ./options.nix

      ./modules/git.nix
      ./modules/gnome.nix
      ./modules/kitty.nix
      ./modules/neovim.nix
      ./modules/tmux.nix
      ./modules/zsh.nix
    ];
  }
