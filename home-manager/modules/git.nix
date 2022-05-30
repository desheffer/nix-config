{ config, lib, ... }:
  lib.mkIf config.userRoles.git {
    programs.git = {
      enable = true;

      delta = {
        enable = true;

        options = {
          navigate = true;
          side-by-side = true;
          syntax-theme = "gruvbox-dark";
        };
      };

      userEmail = "desheffer@gmail.com";
      userName = "Doug Sheffer";

      extraConfig = {
        github.user = "desheffer";
      };
    };
  }
