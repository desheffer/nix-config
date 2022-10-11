{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.cli;

in {
  options.modules.cli = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most CLI applications.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        agenix
        dnsutils
        git
        htop
        killall
        python3
        wget
        zsh
      ];

      pathsToLink = [
        "/share/zsh"
      ];
    };
  };
}
