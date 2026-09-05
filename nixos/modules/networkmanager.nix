{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.networkmanager;

in
{
  options.modules.networkmanager = { };

  config = mkIf config.networking.networkmanager.enable {
    # BUG: waiting for full NetworkManager startup can stall `nixos-rebuild
    # switch`, so wait only for connectivity.
    # See https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
      ""
      "${pkgs.networkmanager}/bin/nm-online -q"
    ];
  };
}
