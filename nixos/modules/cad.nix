{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.cad;

in
{
  options.modules.cad = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable CAD tools.";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (
        let
          name = "BambuStudio";
          pname = "bambu-studio";
          version = "02.05.00.67";
          ubuntu_version = "24.04_PR-9540";

          src = fetchurl {
            url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-${ubuntu_version}.AppImage";
            sha256 = "sha256-3ubZblrsOJzz1p34QiiwiagKaB7nI8xDeadFWHBkWfg=";
          };

          appimageContents = appimageTools.extractType2 { inherit pname version src; };

        in
        appimageTools.wrapType2 {
          inherit
            name
            pname
            version
            src
            ;

          profile = ''
            export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
          '';

          extraPkgs = pkgs: [
            cacert
            glib
            glib-networking
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            webkitgtk_4_1
          ];

          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/BambuStudio.desktop \
              $out/share/applications/BambuStudio.desktop

            for size in 32 128 192; do
              square=$(printf "%sx%s" $size $size)
              install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/$square/apps/BambuStudio.png \
                $out/share/icons/hicolor/$square/apps/BambuStudio.png
            done

            substituteInPlace $out/share/applications/BambuStudio.desktop \
              --replace-fail "Exec=AppRun" "Exec=bambu-studio"
          '';
        }
      )
    ];
  };
}
