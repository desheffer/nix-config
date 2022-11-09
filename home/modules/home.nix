{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.home;

in
{
  options.modules.home = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable common home options.";
      default = config.modules.cli.enable;
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
        cat = "bat --style=plain";

        "chown." = "sudo chown -R \"\${USER}\": .";

        df = "df -hT";

        dkr-sh = "docker run -it --rm --entrypoint sh";
        dkr-sh-v = "docker run -it --rm --entrypoint sh -v \"\${PWD}\":/pwd";
        dkr-stop = "[ -z \"$(docker ps -q)\" ] || docker stop $(docker ps -q)";

        d = "cd \"$(git rev-parse --show-toplevel || echo .)\"";
        ga = "git add";
        gap = "git add -p";
        gb = "git branch";
        gbd = "git branch -d";
        gbD = "git branch -D";
        gc = "git commit --verbose";
        gca = "git commit --verbose --amend";
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
        gl = "git log";
        glo = "git log --oneline";
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
        gPod = "git push origin :\"$(git branch --show-current)\"";
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
        gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m 'WIP [skip ci]'";

        gh-https-to-ssh = "git remote set-url origin \"$(git remote get-url origin | sed 's|https://github.com/|git@github.com:|')\"";

        la = "exa -aahlF --git --group-directories-first";
        ll = "exa -hlF --git --group-directories-first";
        ls = "exa -F --group-directories-first";
        tree = "exa -T --group-directories-first";

        ta = "tmux attach";
        tmux = "tmux -2u";
      };
    };
  };
}
