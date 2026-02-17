{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.home;

in
{
  options.modules.home = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable common home options.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        "Code/.keep" = {
          text = "";
        };
      };

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        c = "cd ~/Code";

        cat = "bat --style=plain";

        cc = "claude";

        "chown." = "sudo chown -R \"\${USER}\": .";

        df = "df -hT";

        dkr-bash = "docker run -it --rm --entrypoint bash";
        dkr-bash-v = "docker run -it --rm --entrypoint bash -v \"\${PWD}\":/pwd -w /pwd";
        dkr-run = "docker run -it --rm";
        dkr-sh = "docker run -it --rm --entrypoint sh";
        dkr-sh-v = "docker run -it --rm --entrypoint sh -v \"\${PWD}\":/pwd -w /pwd";
        dkr-stop = "[ -z \"$(docker ps -q)\" ] || docker stop $(docker ps -q)";

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

        jdtls-clean = "rm -rf ~/.cache/jdtls .classpath .gradle .project .settings build";

        ls = "eza --classify=always --git --group-directories-first";
        l = "ls -aahl";
        la = "ls -ah";
        ll = "ls -hl";
        lla = "ls -ahl";
        lt = "ls --tree";

        # "If the last character of the alias value is a space or tab
        # character, then the next command word following the alias is also
        # checked for alias expansion."
        sudo = "sudo -E ";

        ta = "tmux new-session -A -s";
        tmux = "tmux -2u";
      };
    };
  };
}
