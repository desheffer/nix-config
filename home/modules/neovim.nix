{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.neovim;

in
{
  options.modules.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable Neovim.";
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim-config = {
      enable = true;

      lsp.enable = true;
    };
  };
}
