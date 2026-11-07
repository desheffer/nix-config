{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.libreoffice;

in
{
  options.modules.libreoffice = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable LibreOffice.";
      default = config.modules.gui.enable;
    };
  };

  config = lib.mkIf cfg.enable { home.packages = with pkgs; [ libreoffice ]; };
}
