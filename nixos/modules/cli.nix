{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.cli;

in
{
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
        bash
        dnsutils
        git
        htop
        killall
        python3
        wget
        zsh
      ];

      shells = [ pkgs.zsh ];

      pathsToLink = [ "/share/zsh" ];
    };

    system.activationScripts.bin.text = ''
      ln -sfn /run/current-system/sw/bin/bash /bin/bash
    '';
  };
}
