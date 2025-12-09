{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.deskflow;

  # TODO: Remove when available in nixpkgs.
  deskflow = pkgs.deskflow.overrideAttrs (oldAttrs: rec {
    version = "1.25.0";

    src = pkgs.fetchFromGitHub {
      owner = "deskflow";
      repo = "deskflow";
      tag = "v${version}";
      hash = "sha256-IclKXYCvYHMK4e1z1efmOHUaJqnmZgofK5r6Ml+i5OI=";
    };

    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.kdePackages.qttools
    ];
  });

  # TODO: Remove when available in nixpkgs.
  wl-clipboard = pkgs.wl-clipboard.overrideAttrs (oldAttrs: rec {
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "bugaevc";
      repo = "wl-clipboard";
      rev = "e8082035dafe0241739d7f7d16f7ecfd2ce06172";
      hash = "sha256-sR/P+urw3LwAxwjckJP3tFeUfg5Axni+Z+F3mcEqznw=";
    };
  });

in
{
  options.modules.deskflow = {
    enableServer = mkOption {
      type = types.bool;
      description = "Whether to enable the Deskflow server.";
      default = false;
    };

    config = mkOption {
      type = types.lines;
      description = "Deskflow configuration file contents.";
      default = "";
    };

    settings = mkOption {
      type = types.lines;
      description = "Deskflow settings file contents.";
      default = "";
    };

    enableClient = mkOption {
      type = types.bool;
      description = "Whether to enable the Deskflow client.";
      default = false;
    };

    serverAddress = mkOption {
      type = types.str;
      description = "Address of the Deskflow server.";
      default = "";
    };
  };

  config = mkIf (cfg.enableServer || cfg.enableClient) {
    environment.systemPackages = with pkgs; [
      deskflow
      wl-clipboard
    ];

    networking.firewall.allowedTCPPorts = [ 24800 ];

    # environment = {
    #   etc = {
    #     "Deskflow/deskflow-server.conf" = {
    #       text = cfg.config;
    #     };
    #     "Deskflow/Deskflow.conf" = {
    #       text = cfg.settings;
    #     };
    #     # XXX: temporary
    #     "Deskflow/tls/deskflow.pem" = {
    #       text = ''
    #         -----BEGIN PRIVATE KEY-----
    #         MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCqenQKD6OHdk3b
    #         Q6K99DA4IWloDOpWKhkDniUCMGDEWfifka1wy14BikX6AFjEngo5WCJumfjum1rS
    #         kg6nP4KOtSU67WeZXm1Ci/ZjYHTIq3843Z6qVQYvdXClNMSNIFx7aXaIcOQNMWDk
    #         Ow7cDz41LQIjc6xWD5xA/+FktF2P/uF8rP5A+wcVt8u64iXnMIaxpftX8DyS4kkE
    #         iJVD3WcIkgV0R7zYkzNt65YcG3eX8IX1MU+W4dg3xInVIBZtu1eb6PsImXOKjUeH
    #         ljcjYFEVsbfDCB3ftHr2N3TD6OW7CLWUXkAsePNQuLDHa1Xfi86KHwn2e+B9fFnQ
    #         IuMzBZZHAgMBAAECggEAEELe8U8j+gAxLzJb6MLNAkWmafwbzDB2zPWkS3moeU8P
    #         T2htz73UtgPlzRHqzB86rW6e1i4n5KauYQb49wx9T4Li54rzeb/1xXlXsFhoIcFB
    #         QOZ1Q7azGnEy15qMo90lRS/xoQeK3hR9zND/VI+8Dzlyvav2d9aqwNGt9iIOow7B
    #         dm1E57IHGDnsfU4oT+9UAEBslJXwLlIc8jf4VtskI3ObxgKQ2A8Q+AN4l5dTTIfJ
    #         hruiwK2+0faqhOddfseM5s6aEkIqFm9QagvZGKlWJPdU4DC4RfsbyM0gz6cCNV0L
    #         qjl7Htfw0qHKyLYTj1vsDzwSjnFd2HLbyVJU+oB7BQKBgQDr9QrcBvq0vNqK5e7n
    #         +1I68trQwQXCarMHk0+uGYREOZp2lhQ+3eJ4TU/ar+TYxx6e4DzKYypRjp7npuGe
    #         Fa9pyGFpbRajZIgp7NheIaTMVp9x+kMX58ERWKGJxyvppun1tRWoMgWH4Z6t46+9
    #         o1oXDcuUUehwWc2iG9bI6eZqZQKBgQC49Y3TFc6XMUrG//8Wow0FIitntpp5yTbZ
    #         cdcI5nKElq97gV7nDj+UtSAclObrxxL0s5UQIRvO3Kb5swR+wEIQRKqEhWAQWSKz
    #         eemOu5Cb/YX7v0b55FX3wwkFDb2PQmWtIk+irpokAvoPbtFj5c7LKAreiyb9pYgC
    #         QdyYi709OwKBgQCy/u0CBPli6nEPNWaK7QhwV5LPEd6Aodi2QnYLqKfB6cDXfPpW
    #         xpPqlxug1hZQrJz6ATmcfqW3wO2i5eH5vpGXOb9L7slhof35cAajQfp2WLAUErmb
    #         BOBdfFLu5fzV/x00m+6V7XxsnCd32mWTArxxCLILDie6MyXfeCbzuxxkUQKBgExy
    #         sjwdN1amuRGnnfftTORiSy6C+zZ7RIB73TWAirTi04Vo46D88qq0cqFdqlSp49vg
    #         niwcgzHtYdazd5gsPyIaP6CmwB4BuaYVLcQhIpRXJZn4ZY3EIwRVSNUd6Mvd1cjJ
    #         9cB4Cp333QOj+kggJGk0E8oIGgWc9ap5LoSevYkhAoGBAIFWCHWoLudEbpxVg6Ll
    #         S9F0R8WmZiCon4zHW/kg7yH6K/kIEcGXDychs+Gnb9Q5nPXoN5V3SapDeXNyoP71
    #         zHGJKSXkdG9Z2CRJ1luvMiT26+JngI2aCrUjrHsMO6xOWV2W/c6lNS9Mh/ucTdP2
    #         4DfzqcpCRfCMzusxZvsknNgh
    #         -----END PRIVATE KEY-----
    #         -----BEGIN CERTIFICATE-----
    #         MIICmjCCAYICAQEwDQYJKoZIhvcNAQELBQAwEzERMA8GA1UEAwwIRGVza2Zsb3cw
    #         HhcNMjUxMjA5MDQ1NDIxWhcNMjYxMjA5MDQ1NDIxWjATMREwDwYDVQQDDAhEZXNr
    #         ZmxvdzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKp6dAoPo4d2TdtD
    #         or30MDghaWgM6lYqGQOeJQIwYMRZ+J+RrXDLXgGKRfoAWMSeCjlYIm6Z+O6bWtKS
    #         Dqc/go61JTrtZ5lebUKL9mNgdMirfzjdnqpVBi91cKU0xI0gXHtpdohw5A0xYOQ7
    #         DtwPPjUtAiNzrFYPnED/4WS0XY/+4Xys/kD7BxW3y7riJecwhrGl+1fwPJLiSQSI
    #         lUPdZwiSBXRHvNiTM23rlhwbd5fwhfUxT5bh2DfEidUgFm27V5vo+wiZc4qNR4eW
    #         NyNgURWxt8MIHd+0evY3dMPo5bsItZReQCx481C4sMdrVd+LzoofCfZ74H18WdAi
    #         4zMFlkcCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAYeTNFvK+vh8zbIa4uF3YehXA
    #         uWPI35tKApqOp48R9cXQO6th9Ew242IikRu/5j9MfZNSGe7N8bSt2o9vZAZixeBF
    #         rUPD81w/W45zkSzcl12Fp7KNSs6RsuGVk3vpBaODrE5meRBP4CtyV73lS958brSt
    #         H45UDXBcySIFD1AdQ1CJboAYQ23kUt1rOO1djlzuoBUmVuq0jx8xiJ/r2fdcAaWP
    #         Pb0cwgLCGF13VRUpX6/L78YuwD92iRRgEwzyNoMqVtEAJfW7ro5ouh4SrD1t38Uj
    #         8D4qS0b5cWm3mPdpZ3tXl054F2BGpdoOkuap5coGFHZpaGfY0iNONNrkvKqCOA==
    #         -----END CERTIFICATE-----
    #       '';
    #     };
    #   };
    # };

    # systemd.user.services.deskflow-server = mkIf cfg.enableServer {
    #   after = [
    #     "network.target"
    #     "graphical-session.target"
    #   ];
    #   description = "deskflow server";
    #   wantedBy = [ "graphical-session.target" ];
    #   path = [ deskflow ];
    #   serviceConfig.ExecStart = ''${deskflow}/bin/deskflow-core server --settings /etc/Deskflow/Deskflow.conf --config /etc/Deskflow/deskflow-server.conf --no-daemon --enable-crypto --tls-cert /etc/Deskflow/tls/deskflow.pem'';
    #   serviceConfig.Restart = "on-failure";
    # };
    #
    # systemd.user.services.deskflow-client = mkIf cfg.enableClient {
    #   after = [
    #     "network.target"
    #     "graphical-session.target"
    #   ];
    #   description = "deskflow client";
    #   wantedBy = [ "graphical-session.target" ];
    #   path = [ deskflow ];
    #   serviceConfig.ExecStart = ''${deskflow}/bin/deskflow-core client --no-daemon --enable-crypto --tls-cert /etc/Deskflow/tls/deskflow.pem "${cfg.serverAddress}"'';
    #   serviceConfig.Restart = "on-failure";
    # };
  };
}
