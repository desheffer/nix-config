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

      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
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
          "$nix_shell"
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

        nix_shell = {
          format = "via [$symbol$name]($style) ";
          symbol = " ";
        };

        python.format = "[$virtualenv]($style)";
      };
    };

    programs.direnv = {
      enable = true;

      nix-direnv.enable = true;
    };
  };
}
