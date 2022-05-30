{ config, lib, ... }:
  with lib; {
    options.userRoles = {
      cli = mkOption {
        type = types.bool;
        description = "Whether to enable most CLI applications.";
        default = false;
      };
      git = mkOption {
        type = types.bool;
        description = "Whether to enable Git.";
        default = config.userRoles.cli;
      };
      gnome = mkOption {
        type = types.bool;
        description = "Whether to enable GNOME with most GUI applications.";
        default = false;
      };
      gui = mkOption {
        type = types.bool;
        description = "Whether to enable most GUI applications.";
        default = config.userRoles.gnome;
      };
      kitty = mkOption {
        type = types.bool;
        description = "Whether to enable Kitty terminal emulator.";
        default = config.userRoles.gui;
      };
      neovim = mkOption {
        type = types.bool;
        description = "Whether to enable Neovim.";
        default = config.userRoles.cli;
      };
      tmux = mkOption {
        type = types.bool;
        description = "Whether to enable tmux.";
        default = config.userRoles.cli;
      };
      zsh = mkOption {
        type = types.bool;
        description = "Whether to enable Z shell (Zsh).";
        default = config.userRoles.cli;
      };
    };
  }
