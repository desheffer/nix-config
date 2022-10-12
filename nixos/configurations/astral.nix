inputs@{ nixos-hardware, ... }:

let
  lib = import ../../lib inputs;
  keys = import ../../secrets/keys.nix;

in lib.mkNixosConfiguration {
  hostname = "astral";
  system = "x86_64-linux";
  modules = [
    ({ pkgs, ... }: {
      boot = {
        # Linux >=5.17 is required for wifi functionality.
        kernelPackages = pkgs.linuxPackages_5_19;

        initrd = {
          availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
          kernelModules = [ ];
        };

        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };
    })

    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-nvidia
    nixos-hardware.nixosModules.common-pc-ssd
    {
      hardware.nvidia.prime.offload.enable = false;
    }

    {
      modules.docker.enable = true;
      modules.docker.enableNvidia = true;
      modules.gnome.enable = true;
      modules.hidpi.enable = true;
    }

    (lib.mkNixosUserConfiguration {
      username = "desheffer";
      initialPassword = "nix";
      extraGroups = [ "docker" "wheel" ];
      modules = [
        {
          modules.agenix.enable = true;
          modules.cli.enable = true;
          modules.gnome.enable = true;
          modules.hidpi.enable = true;
        }
      ];
      authorizedKeys = [
        keys.users.desheffer
      ];
    })

    ({ pkgs, ... }: {
      environment = {
        systemPackages = with pkgs; [
          barrier
        ];

        etc = {
          "barrier.conf" = {
            text = ''
              section: screens
                astral:
                ethereal:
              end

              section: aliases
              end

              section: links
                astral:
                  left = ethereal
                ethereal:
                  right = astral
              end
            '';
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 24800 ];

      systemd.user.services.barrier-server = {
        after = [ "network.target" "graphical-session.target" ];
        description = "barrier server";
        wantedBy = [ "graphical-session.target" ];
        path = [ pkgs.barrier ];
        serviceConfig.ExecStart = ''${pkgs.barrier}/bin/barriers -f --config /etc/barrier.conf --disable-crypto'';
        serviceConfig.Restart = "on-failure";
      };
    })
  ];
}
