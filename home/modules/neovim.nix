{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.neovim;

in
{
  options.modules.neovim = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable Neovim.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.neovim-config = {
      enable = true;

      lsp.enable = true;
    };
  };
}
