{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.nix;

in {
  config = {
    nix = {
      extraOptions = "experimental-features = nix-command flakes";
      package = pkgs.nixFlakes;

      gc = {
        automatic = true;
        dates = "Sat *-*-* 06:00:00 US/Eastern";
        options = "--delete-older-than 7d";
        persistent = true;
      };
    };
  };
}
