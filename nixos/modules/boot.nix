{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.boot;

in
{
  options.modules.boot = { };

  config = {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;

        systemd-boot = {
          enable = true;
          configurationLimit = 16;
          consoleMode = "0";
        };
      };

      # BUG: CVE-2026-31431 ("Copy Fail"). Remove once all hosts are on a
      # kernel containing a664bf3d603d (>= 6.12.85, 6.18.22, 6.19.12, or 7.0).
      extraModprobeConfig = "install algif_aead /bin/false";
    };
  };
}
