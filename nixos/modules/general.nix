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
    };

    hardware.enableRedistributableFirmware = true;

    time.timeZone = "US/Eastern";

    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;
    };

    environment = {
      systemPackages = with pkgs; [
        git
        git-crypt
        zsh
      ];

      pathsToLink = [
        "/share/zsh"
      ];
    };
  };
}
