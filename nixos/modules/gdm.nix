{ config, lib, ... }:
  lib.mkIf config.hostRoles.gdm {
    services.xserver = {
      displayManager.gdm.enable = true;
    };
  }
