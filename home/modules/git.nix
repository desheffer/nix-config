{ config, lib, ... }:

with lib;

let
  cfg = config.homeConfig.git;

in {
  options.homeConfig.git = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Git.";
      default = config.homeConfig.cli.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      delta = {
        enable = true;

        options = {
          navigate = true;
          side-by-side = true;
          syntax-theme = "gruvbox-dark";
        };
      };

      userEmail = "desheffer@gmail.com";
      userName = "Doug Sheffer";

      extraConfig = {
        github.user = "desheffer";
      };
    };
  };
}
