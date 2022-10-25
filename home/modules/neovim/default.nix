{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.neovim;

  alpha-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "alpha-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "goolord";
      repo = "alpha-nvim";
      rev = "4781fcfea5ddc1a92d41b32dc325132ed6fce7a8";
      sha256 = "sha256-GA+fIfVlHOllojGyErYGC0+zyYTl9rOxendqOgApJw4=";
    };
  };

  spellsitter-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "spellsitter-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "lewis6991";
      repo = "spellsitter.nvim";
      rev = "f84e7a31c516f2a9cb857a02e4b551b009a81afb";
      sha256 = "sha256-lYyTA9hvxljNy0n3xZCCwC1e+W1mBBwdGDKXiWY1x4E=";
    };
  };

in {
  options.modules.neovim = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Neovim.";
      default = config.modules.cli.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        # Colorscheme:
        gruvbox-material

        # Interface:
        nvim-web-devicons
        alpha-nvim
        bufferline-nvim
        lualine-nvim

        # Telescope:
        telescope-nvim
        telescope-ui-select-nvim

        # Sessions:
        auto-session

        # Explorer:
        nvim-tree-lua

        # Treesitter:
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        spellsitter-nvim
        nvim-treesitter-context

        # Language server:
        nvim-lspconfig
        lsp_signature-nvim

        # Completion:
        nvim-cmp
        cmp-buffer
        cmp-nvim-lsp
        luasnip
        cmp_luasnip
        friendly-snippets
        nvim-autopairs

        # Navigation:
        hop-nvim
        neoscroll-nvim
        vim-signature

        # Search:
        vim-asterisk
        nvim-hlslens

        # Clipboard:
        registers-nvim

        # Editing:
        comment-nvim
        vim-unimpaired
        vim-surround
        vim-repeat
        vim-easy-align
        vim-argumentative

        # Git:
        gitsigns-nvim

        # Whitespace:
        indent-blankline-nvim

        # Terminal:
        vim-tmux-navigator
        FTerm-nvim
      ];

      extraPackages = with pkgs; with nodePackages; [
        bash-language-server
        ccls
        dockerfile-language-server-nodejs
        gopls go
        intelephense
        jdt-language-server jdk17_headless
        pyright
        rnix-lsp
        sumneko-lua-language-server
        vscode-css-languageserver-bin
        vscode-html-languageserver-bin
        vscode-json-languageserver-bin
        yaml-language-server
      ];

      extraConfig = ''
        lua require("init")
      '';
    };

    xdg.configFile = {
      "nvim/lua" = {
        source = config.lib.file.mkOutOfStoreSymlink "/etc/nix-config/home/modules/neovim/lua";
        recursive = true;
      };
    };
  };
}
