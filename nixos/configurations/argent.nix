inputs@{ nixos-hardware, secrets, ... }:

let
  lib = import ../../lib inputs;
  passwords = secrets.nixosModules.passwords;

in
lib.mkNixosConfiguration {
  hostname = "argent";
  system = "x86_64-linux";
  permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.74"
  ];
  modules = [
    (
      { config, ... }:
      {
        boot = {
          initrd = {
            availableKernelModules = [
              "xhci_pci"
              "ahci"
              "usb_storage"
              "usbhid"
              "sd_mod"
            ];
            kernelModules = [ "dm-snapshot" ];
          };

          kernelModules = [
            "kvm-intel"
            "wl"
          ];
          extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
        };
      }
    )

    nixos-hardware.nixosModules.apple-macbook-pro
    nixos-hardware.nixosModules.common-hidpi
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    {
      hardware.facetimehd = {
        enable = true;
        withCalibration = true;
      };
    }

    {
      modules.autoUpgrade.enable = true;
      modules.docker.enable = true;
      modules.gnome.enable = true;
      modules.printing.enable = true;
      modules.secrets.enable = true;

      modules.lanMouse = {
        enable = true;
        config = ''
          [right]
          hostname = "astral"
          activate_on_startup = true
        '';
      };
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialHashedPassword = passwords.desheffer;
      avatar = "headphones.jpg";
      extraGroups = [
        "dialout"
        "docker"
        "networkmanager"
        "wheel"
      ];
      modules = [
        {
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.secrets.enable = true;
        }
      ];
    })
  ];
}
