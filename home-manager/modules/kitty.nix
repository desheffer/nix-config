{ config, lib, ... }:
  lib.mkIf config.userRoles.kitty {
    programs.kitty = {
      enable = true;
    };
  }
