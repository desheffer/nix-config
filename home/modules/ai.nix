{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.ai;

  claude-plugins-official = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-official";
    rev = "b664e152af5742dd11b6a6e5d7a65848a8c5a261";
    hash = "sha256-Dd3AZzGvVsXACixRdmQcEHT7FwPxOyGnvI67ypj+i+Y=";
  };

  superpowers = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "b55764852ac78870e65c6565fb585b6cd8b3c5c9";
    hash = "sha256-cobQloF7Y6K0IC0/6xSnA2Io+fKgk2SRmCwoZZtVCco=";
  };

  claude-code-wrapped = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ pkgs.claude-code ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --add-flags "--plugin-dir ${claude-plugins-official}/plugins/code-simplifier" \
        --add-flags "--plugin-dir ${superpowers}"
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
    programs.claude-code = {
      enable = true;
      package = claude-code-wrapped;

      settings = {
        mcpServers = {
          atlassian-rovo-mcp = {
            type = "http";
            url = "https://mcp.atlassian.com/v1/mcp";
          };
        };
        permissions = {
          allow = [
            "Edit"
            "Read(/nix/store/**)"
            "Read(~/Code/**)"
            "WebFetch"
            "WebSearch"
            "Write"

            "Bash(awk *)"
            "Bash(cat *)"
            "Bash(cut *)"
            "Bash(diff *)"
            "Bash(docker compose exec * ./gradlew *)"
            "Bash(file *)"
            "Bash(find *)"
            "Bash(gh api search/*)"
            "Bash(gh issue list *)"
            "Bash(gh issue view *)"
            "Bash(gh pr list *)"
            "Bash(gh pr view *)"
            "Bash(gh release list *)"
            "Bash(gh release view *)"
            "Bash(gh repo view *)"
            "Bash(gh run list *)"
            "Bash(gh run view *)"
            "Bash(gh search *)"
            "Bash(gh workflow list *)"
            "Bash(gh workflow view *)"
            "Bash(git blame *)"
            "Bash(git branch *)"
            "Bash(git describe *)"
            "Bash(git diff *)"
            "Bash(git log *)"
            "Bash(git ls-files *)"
            "Bash(git ls-remote *)"
            "Bash(git ls-tree *)"
            "Bash(git remote -v)"
            "Bash(git rev-parse *)"
            "Bash(git show *)"
            "Bash(git status *)"
            "Bash(git worktree list *)"
            "Bash(grep *)"
            "Bash(head *)"
            "Bash(jq *)"
            "Bash(ls *)"
            "Bash(make down)"
            "Bash(make restart)"
            "Bash(make start)"
            "Bash(make stop)"
            "Bash(make up)"
            "Bash(mkdir *)"
            "Bash(nix eval *)"
            "Bash(nix flake metadata *)"
            "Bash(nix flake show *)"
            "Bash(pwd *)"
            "Bash(rg *)"
            "Bash(rmdir *)"
            "Bash(sort *)"
            "Bash(stat *)"
            "Bash(tail *)"
            "Bash(tree *)"
            "Bash(uniq *)"
            "Bash(wc *)"
            "Bash(which *)"
          ];
          deny = [
            "Read(~/Code/secrets/**)"
          ];
        };
        feedbackSurveyRate = 0.0;
        showTurnDuration = false;
        spinnerTipsEnabled = false;
        spinnerVerbs = {
          mode = "replace";
          verbs = [ "Processing" ];
        };
      };
    };

  };
}
