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
        bash
        btop
        dnsutils
        git
        htop
        killall
        openssl
        python3
        s-tui
        wget
        zsh
      ];

      shells = [ pkgs.zsh ];

      pathsToLink = [ "/share/zsh" ];

      variables = {
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };

    system.activationScripts.bin.text = ''
      mkdir -p /bin
      ln -sfn /run/current-system/sw/bin/bash /bin/bash
    '';
  };
}
