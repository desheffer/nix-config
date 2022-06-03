{ config, lib, ... }:

with lib;

let
  cfg = config.homeConfig.neovim;

in {
  options.homeConfig.neovim = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Neovim.";
      default = config.homeConfig.cli.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
    };
  };
}
