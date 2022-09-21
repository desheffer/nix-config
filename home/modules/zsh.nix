{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.zsh;

in {
  options.modules.zsh = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Z shell (Zsh).";
      default = config.modules.cli.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;

      autocd = true;

      defaultKeymap = "emacs";

      history = {
        extended = true;
        share = false;
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

        la = "exa -ahlF --git --group-directories-first";
        ll = "exa -hlF --git --group-directories-first";
        ls = "exa -F --group-directories-first";
        tree = "exa -T --group-directories-first";

        ta = "tmux attach";
        tmux = "tmux -2u";
      };

      initExtra = ''
        PATH="''${PATH}:''${HOME}/.nix-profile/bin"

        # Append history, do not replace it.
        setopt APPEND_HISTORY

        # Ignore duplicates when searching.
        setopt HIST_FIND_NO_DUPS

        # Append history immediately.
        setopt INC_APPEND_HISTORY

        # Do not beep.
        unsetopt BEEP

        zstyle ':completion:*' completer _expand_alias _complete _ignored
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*:commands' rehash 1
        zstyle ':completion:*:*:*:*:*' menu select

        bindkey '^[[1;5C' forward-word        # Ctrl + Right
        bindkey '^[[1;5D' backward-word       # Ctrl + Left
        bindkey '^[[H'    beginning-of-line   # Home
        bindkey '^[[F'    end-of-line         # End
        bindkey '^[[3~'   delete-char         # Del
        bindkey '^H'      backward-kill-word  # Ctrl + Backspace
        bindkey '^[[5~'   beep                # PageDown
        bindkey '^[[6~'   beep                # PageUp
        bindkey '^[[5;3~' beep                # Alt + PageDown (no-op)
        bindkey '^[[6;3~' beep                # Alt + PageUp (no-op)
      '';
    };

    programs.bat = {
      enable = true;

      config.theme = "gruvbox-dark";
    };

    programs.exa = {
      enable = true;
    };

    programs.starship = {
      enable = true;

      enableBashIntegration = false;

      settings = {
        format = concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$python"
          "$jobs"
          "$character"
        ];

        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
          vicmd_symbol = "[<](bold green)";
        };

        directory = {
          read_only = " ";
          repo_root_style = "underline bold cyan";
          truncate_to_repo = false;
          truncation_length = 0;
          truncation_symbol = "…/";
        };

        git_branch.symbol = " ";

        hostname.disabled = false;

        python.format = "[$virtualenv]($style)";
      };
    };

    programs.direnv = {
      enable = true;

      nix-direnv.enable = true;
    };
  };
}
