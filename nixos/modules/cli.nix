{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.cli;

in
{
  options.modules.cli = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable extra CLI applications.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
    };

    programs.htop = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      bash
      btop
      dnsutils
      killall
      openssl
      wget
    ];

    system.activationScripts.bin.text = ''
      mkdir -p /bin
      ln -sfn /run/current-system/sw/bin/bash /bin/bash
    '';
  };
}
