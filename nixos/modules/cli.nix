{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.nixosConfig.cli;

in {
  options.nixosConfig.cli = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most CLI applications.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        dnsutils
        htop
        killall
        python
        wget
        zsh
      ];

      pathsToLink = [
        "/share/zsh"
      ];
    };
  };
}
