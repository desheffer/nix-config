{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.zsh;

in {
  options.homeConfig.zsh = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Z shell (Zsh).";
      default = config.homeConfig.cli.enable;
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

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        cat = "bat --style=plain";

        "chown." = "sudo chown -R \"\${USER}\": .";

        df = "df -hT";

        dkr-sh = "docker run -it --rm --entrypoint sh";
        dkr-sh-v = "docker run -it --rm --entrypoint sh -v \"\${PWD}\":/pwd";
        dkr-stop = "[ ! -z \"$(docker ps -q)\" ] && docker stop $(docker ps -q)";

        d = "cd \"$(git rev-parse --show-cdup)\"";
        ga = "git add";
        gap = "git add -p";
        gb = "git branch";
        gbl = "git branch --sort=committerdate";
        gc = "git commit --verbose";
        gca = "git commit --verbose --amend";
        gcdf = "git clean -d --force";
        gco = "git checkout";
        gcop = "git checkout -p";
        gd = "git diff";
        gdc = "git diff --cached";
        gf = "git fetch";
        gl = "git log";
        gl1 = "git log --oneline";
        glp = "git log -p";
        gls = "git log --stat";
        gm = "git merge";
        gp = "git pull";
        gpr = "git pull --rebase";
        gP = "git push";
        gPf = "git push --force-with-lease";
        gPo = "git push origin HEAD";
        gPof = "git push origin HEAD --force-with-lease";
        gr = "git rebase";
        gri = "git rebase -i";
        grs = "git restore --staged";
        gRo = "git reset --hard origin/\"$(git branch --show-current)\"";
        gs = "git status";
        gsp = "git show -p";
        gS = "git add -A && git commit -m SAVE";

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

        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*:commands' rehash 1
        zstyle ':completion:*:*:*:*:*' menu select

        bindkey '^[[H'    beginning-of-line  # Home
        bindkey '^[[F'    end-of-line        # End
        bindkey '^[[3~'   delete-char        # Del
        bindkey '^H'      backward-kill-word # Ctrl + Backspace
        bindkey '^[[5~'   beep               # PageDown
        bindkey '^[[6~'   beep               # PageUp
        bindkey '^[[5;3~' beep               # Alt + PageDown
        bindkey '^[[6;3~' beep               # Alt + PageUp
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
          "$jobs"
          "$character"
        ];

        directory = {
          read_only = " ";
          truncate_to_repo = false;
        };

        hostname.disabled = false;

        git_branch.symbol = " ";
      };
    };
  };
}
