{ pkgs, ... }:
  {
    nix = {
      extraOptions = "experimental-features = nix-command flakes";
      package = pkgs.nixFlakes;
    };

    time.timeZone = "US/Eastern";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

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
  }
