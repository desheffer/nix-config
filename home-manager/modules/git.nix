{ config, lib, ... }:
  lib.mkIf config.userRoles.git {
    programs.git = {
      enable = true;

      userEmail = "desheffer@gmail.com";
      userName = "Doug Sheffer";

      extraConfig = {
        github.user = "desheffer";
      };
    };
  }
