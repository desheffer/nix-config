{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.git;

in
{
  options.modules.git = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Git.";
      default = config.modules.cli.enable;
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
        init.defaultBranch = "main";
        log.date = "iso-local";
        rebase.autoSquash = true;
      };
    };

    home.packages = with pkgs; [
      git-absorb
    ];
  };
}
