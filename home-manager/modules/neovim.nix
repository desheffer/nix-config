{ config, lib, ... }:
  lib.mkIf config.userRoles.neovim {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
    };
  }
