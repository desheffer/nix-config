{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.libreoffice;

in
{
  options.modules.libreoffice = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable LibreOffice.";
      default = config.modules.gui.enable;
    };
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ libreoffice ]; };
}
