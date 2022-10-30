{ config, lib, pkgs, modulesPath, ... }:

with lib;

let
  cfg = config.modules.locale;

in
{
  options.modules.locale = { };

  config = {
    time.timeZone = "US/Eastern";

    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";
  };
}
