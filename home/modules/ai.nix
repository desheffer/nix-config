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
        mcp = {
          atlassian-rovo-mcp = {
            type = "remote";
            url = "https://mcp.atlassian.com/v1/mcp";
            enabled = true;
          };
        };
        keybinds = {
          session_child_cycle = "<leader>right,ctrl+pagedown";
          session_child_cycle_reverse = "<leader>left,ctrl+pageup";
          session_parent = "<leader>up,ctrl+home";
        };
        permission = {
          bash = {
            "*" = "ask";

            "docker compose exec * ./gradlew *" = "allow";
            "find *" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git status *" = "allow";
            "grep *" = "allow";
            "head *" = "allow";
            "ls *" = "allow";
            "make down" = "allow";
            "make restart" = "allow";
            "make start" = "allow";
            "make stop" = "allow";
            "make up" = "allow";
            "pwd" = "allow";
            "rg *" = "allow";
            "sort *" = "allow";
            "tail *" = "allow";
          };
          external_directory = {
            "~/Code/**" = "allow";
            "~/Code/secrets" = "deny";
          };
          edit = {
            "~/Code/**" = "deny";
          };
        };
      };
    };
  };
}
