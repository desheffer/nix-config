{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.git;

in
{
  options.modules.git = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Git.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          email = "desheffer@gmail.com";
          name = "Doug Sheffer";
        };

        github.user = "desheffer";
        init.defaultBranch = "main";
        log.date = "iso-local";
        rebase.autoSquash = true;
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;

      options = {
        navigate = true;
        side-by-side = true;
        syntax-theme = "gruvbox-dark";
      };
    };

    home.packages = with pkgs; [ git-absorb ];
  };
}
