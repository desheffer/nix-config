{ config, lib, ... }:
  lib.mkIf config.userRoles.zsh {
    programs.zsh = {
      enable = true;

      sessionVariables = {
        EDITOR = "nvim";
      };
    };
  }
