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
    home.packages = with pkgs; [
      git-absorb
      git-town
    ];

    home.shellAliases = {
      d = "cd \"$(git rev-parse --show-toplevel || echo .)\"";
      ga = "git add";
      gab = "git absorb";
      gai = "git add --intent-to-add";
      gap = "git add -p";
      gb = "git branch --sort=-committerdate";
      gbd = "git branch -d";
      gbD = "git branch -D";
      gc = "git commit --verbose";
      gca = "git commit --verbose --amend --date=now";
      gcf = "git commit --fixup";
      gclean = "git clean -d --force";
      gcm = "git commit --allow-empty -m";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcop = "git checkout -p";
      gcp = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";
      gd = "git diff";
      gdc = "git diff --cached";
      gf = "git fetch";
      gl = "git log --graph --pretty=format:'%C(auto)%h %s %C(green)%cr%C(reset) %C(blue)%an%C(reset) %C(auto)%d'";
      gll = "git log";
      glp = "git log -p";
      gls = "git log --stat";
      gm = "git merge";
      gma = "git merge --abort";
      gmc = "git merge --continue";
      gp = "git pull";
      gpr = "git pull --rebase";
      gP = "git push";
      gPf = "git push --force-with-lease";
      gPo = "git push origin --set-upstream \"$(git branch --show-current)\"";
      gPof = "git push origin --set-upstream \"$(git branch --show-current)\" --force-with-lease";
      gr = "git rebase";
      gra = "git rebase --abort";
      grc = "git rebase --continue";
      gri = "git rebase -i";
      grs = "git restore --staged";
      gR = "git reset --hard";
      gRo = "git reset --hard origin/\"$(git branch --show-current)\"";
      gs = "git status";
      gst = "git stash";
      gsta = "git stash apply";
      gstd = "git stash drop";
      gstl = "git stash list";
      gstp = "git stash pop";

      gh-https-to-ssh = "git remote set-url origin \"$(git remote get-url origin | sed 's|https://github.com/|git@github.com:|')\"";
    };

    programs.git = {
      enable = true;

      ignores = [
        ".bash_profile"
        ".bashrc"
        ".claude"
        ".gitconfig"
        ".gitmodules"
        ".mcp.json"
        ".opencode"
        ".profile"
        ".ripgreprc"
        ".vscode"
        ".zprofile"
        ".zshrc"
      ];

      settings = {
        user = {
          email = "desheffer@gmail.com";
          name = "Doug Sheffer";
        };

        github.user = "desheffer";
        init.defaultBranch = "main";
        log.date = "iso-local";
        rebase.autoSquash = true;

        git-town.main-branch = "main";
      };
    };

    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          email = "desheffer@gmail.com";
          name = "Doug Sheffer";
        };

        ui.default-command = "log";
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;

      options = {
        navigate = true;
        paging = "always";
        side-by-side = true;
        syntax-theme = "gruvbox-dark";
      };
    };
  };
}
