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
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
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
