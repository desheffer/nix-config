{ config, lib, pkgs, modulesPath, ... }:

with lib;

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    nix = {
      extraOptions = "experimental-features = nix-command flakes";
      package = pkgs.nixFlakes;

      gc = {
        automatic = true;
        dates = "Sat *-*-* 06:00:00 US/Eastern";
        options = "--delete-older-than 7d";
        persistent = true;
      };
    };

    hardware.enableRedistributableFirmware = true;

    time.timeZone = "US/Eastern";

    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    services.openssh = {
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
