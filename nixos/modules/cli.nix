{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.cli;

in
{
  options.modules.cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable extra CLI applications.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
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
