{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.cli;

in {
  options.modules.cli = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most CLI applications.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    };

    home.packages = with pkgs; [
      awscli2
      jq
      ripgrep
      yq-go
    ];

    xdg.configFile = {
      ".rgignore" = {
        target = "../.rgignore";
        text = ''
          !.*
          .git
        '';
      };
    };
  };
}
