{ config, lib, ... }:
  lib.mkIf config.userRoles.tmux {
    programs.tmux = {
      enable = true;
    };
  }
