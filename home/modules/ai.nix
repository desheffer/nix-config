{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ai;

  opencode-wrapped = pkgs.symlinkJoin {
    name = "opencode";
    paths = [ pkgs.opencode ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode \
        --set OPENCODE_ENABLE_EXA 1 \
        --set OPENCODE_EXPERIMENTAL true
    '';
  };

in
{
  options.modules.ai = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable AI tools.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = opencode-wrapped;

      settings = {
        share = "disabled";
        permission = {
          bash = {
            "*" = "ask";

            "docker compose exec * ./gradlew *" = "allow";
            "find *" = "allow";
            "git add *" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git status *" = "allow";
            "grep *" = "allow";
            "head *" = "allow";
            "ls *" = "allow";
            "pwd" = "allow";
            "rg *" = "allow";
            "sort *" = "allow";
            "tail *" = "allow";
          };
        };
      };
    };
  };
}
