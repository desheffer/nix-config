# nix build .#nixosConfigurations.iso.config.system.build.isoImage
#
# sudo dd if=result/iso/nixos-xxx.iso of=/dev/sda status=progress
# sync

inputs@{ nixpkgs, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;

in
lib.mkNixosConfiguration {
  hostname = "iso";
  system = "x86_64-linux";
  modules = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"

    {
      modules.docker.enable = true;
      modules.fileSystems.enable = false;
      modules.gnome.enable = true;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      extraGroups = [ "docker" "networkmanager" "wheel" ];
      modules = [
        {
          modules.cli.enable = true;
          modules.gnome.enable = true;
        }
      ];
    })
  ];
}
