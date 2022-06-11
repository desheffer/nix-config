{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeConfig.cli;

in {
  options.homeConfig.cli = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable most CLI applications.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
    };

    home.packages = with pkgs; [
      aws
      google-cloud-sdk
      jq
      ripgrep
      yq-go
    ];
  };
}
