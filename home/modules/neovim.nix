{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.neovim;

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

      extraConfig = lib.fileContents ../../nvim/init.vim;

      extraPackages = with pkgs; [
        dotnet-runtime
        gcc
        go
        nodejs nodePackages.npm
        openjdk16-bootstrap
        php81 php81Packages.composer
        unzip
      ];
    };

    xdg.configFile = {
      "nvim/lua" = {
        source = config.lib.file.mkOutOfStoreSymlink "/etc/nix-config/nvim/lua";
        recursive = true;
      };
    };
  };
}
