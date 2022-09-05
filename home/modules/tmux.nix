{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.tmux;

in {
  options.modules.tmux = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable tmux.";
      default = config.modules.cli.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      aggressiveResize = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;
      newSession = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "\${TERM}";

      extraConfig = ''
        # Set window titles.
        set-option -g set-titles on
        set-option -g set-titles-string "#H / #S / #W"

        # Fix Home and End keys.
        bind-key -n Home send Escape '[H'
        bind-key -n End  send Escape '[F'

        # Allow true colors.
        set-option -ga terminal-overrides ',*256col*:Tc'

        # Allow undercurls.
        set-option -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
        set-option -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

        # Split panes using more intuitive keys.
        bind-key '|' split-window -h -c "#{pane_current_path}"
        bind-key '-' split-window -v -c "#{pane_current_path}"

        # Add window navigation options.
        bind-key -n M-Home previous-window
        bind-key -n M-End  next-window

        # Renumber when a window is closed.
        set-option -g renumber-windows on

        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        IS_VIM="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n M-Left  if-shell "''${IS_VIM}" "send-keys C-w h" "select-pane -L"
        bind-key -n M-Down  if-shell "''${IS_VIM}" "send-keys C-w j" "select-pane -D"
        bind-key -n M-Up    if-shell "''${IS_VIM}" "send-keys C-w k" "select-pane -U"
        bind-key -n M-Right if-shell "''${IS_VIM}" "send-keys C-w l" "select-pane -R"

        # Set Gruvbox Dark colors.
        TMUX_THEME_GRAY1="#a89984"
        TMUX_THEME_GRAY2="#504945"
        TMUX_THEME_GRAY3="#3c3836"
        TMUX_THEME_BLACK="#282828"
        TMUX_THEME_YELLOW="#fabd2f"
        TMUX_THEME_BLUE="#83a598"

        # Set section separators.
        TMUX_THEME_SEPLL=""
        TMUX_THEME_SEPLR=""
        TMUX_THEME_SEPRL=""

        # Set left status bar style.
        set-option -g status-left-style bg=''${TMUX_THEME_GRAY3}
        set-option -g status-left "#{?client_prefix,#[fg=''${TMUX_THEME_BLACK}]#[bg=''${TMUX_THEME_YELLOW}]#[bold] #S #[nobold]#[fg=''${TMUX_THEME_YELLOW}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPLR},#[fg=''${TMUX_THEME_BLACK}]#[bg=''${TMUX_THEME_GRAY1}]#[bold] #S #[nobold]#[fg=''${TMUX_THEME_GRAY1}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPLR}}"

        # Set right status bar style.
        set-option -g status-right-style bg=''${TMUX_THEME_GRAY3}
        set-option -g status-right "#[fg=''${TMUX_THEME_GRAY1}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPRL}#[fg=''${TMUX_THEME_BLACK}]#[bg=''${TMUX_THEME_GRAY1}]#[bold] #h #[nobold]"

        # Set window title style.
        set-option -g status-style bg=''${TMUX_THEME_GRAY3}
        set-option -g window-status-current-style ""
        set-option -g window-status-activity-style ""
        set-window-option -g window-status-separator ""
        set-window-option -g window-status-format "#[fg=''${TMUX_THEME_GRAY1}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPLL}#[fg=''${TMUX_THEME_BLACK}]#[bg=''${TMUX_THEME_GRAY1}]#[bold] #I #[nobold]#[fg=''${TMUX_THEME_GRAY1}]#[bg=''${TMUX_THEME_GRAY2}]''${TMUX_THEME_SEPLR}#[fg=''${TMUX_THEME_GRAY1}]#[bold] #W #F #[nobold]#[fg=''${TMUX_THEME_GRAY2}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPLR}"
        set-window-option -g window-status-current-format "#[fg=''${TMUX_THEME_BLUE}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPLL}#[fg=''${TMUX_THEME_BLACK}]#[bg=''${TMUX_THEME_BLUE}]#[bold] #I #[nobold]#[fg=''${TMUX_THEME_BLUE}]#[bg=''${TMUX_THEME_GRAY2}]''${TMUX_THEME_SEPLR}#[fg=''${TMUX_THEME_BLUE}]#[bold] #W #F #[nobold]#[fg=''${TMUX_THEME_GRAY2}]#[bg=''${TMUX_THEME_GRAY3}]''${TMUX_THEME_SEPLR}"

        # Set pane border style.
        set-option -g pane-border-style fg=''${TMUX_THEME_GRAY1},bg=default
        set-option -g pane-active-border-style fg=''${TMUX_THEME_YELLOW},bg=default

        # Set message style.
        set-option -g message-style fg=''${TMUX_THEME_BLACK},bg=''${TMUX_THEME_YELLOW}

        # Set command style.
        set-option -g message-command-style fg=''${TMUX_THEME_BLACK},bg=''${TMUX_THEME_YELLOW}

        # Set pane number style.
        set-option -g display-panes-colour ''${TMUX_THEME_GRAY1}
        set-option -g display-panes-active-colour ''${TMUX_THEME_YELLOW}

        # Set clock style.
        set-window-option -g clock-mode-colour ''${TMUX_THEME_YELLOW}
      '';
    };
  };
}
