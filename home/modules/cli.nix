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
      gh
      gnumake
      jq
      k9s
      kubectl
      python3
      ripgrep
      s-tui
      yq-go
    ];

    home.file = {
      ".rgignore" = {
        text = ''
          !.*
          .git
        '';
      };
    };
  };
}
