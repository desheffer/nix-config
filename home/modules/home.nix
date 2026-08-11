{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.home;

in
{
  options.modules.home = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable common home options.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        "Code/.keep" = {
          text = "";
        };
      };

      sessionVariables = {
        EDITOR = "nvim";
        LOCAL_INFRA = "${config.home.homeDirectory}/Code/gudea/local-infra";
      };

      shellAliases = {
        c = "cd ~/Code";

        "chown." = "sudo chown -R \"\${USER}\": .";

        df = "df -hT";

        dkr-bash = "docker run -it --rm --entrypoint bash";
        dkr-bash-v = "docker run -it --rm --entrypoint bash -v \"\${PWD}\":/pwd -w /pwd";
        dkr-run = "docker run -it --rm";
        dkr-sh = "docker run -it --rm --entrypoint sh";
        dkr-sh-v = "docker run -it --rm --entrypoint sh -v \"\${PWD}\":/pwd -w /pwd";
        dkr-stop = "[ -z \"$(docker ps -q)\" ] || docker stop $(docker ps -q)";

        jdtls-clean = "rm -rf ~/.cache/jdtls .classpath .gradle .project .settings build";

        # "If the last character of the alias value is a space or tab
        # character, then the next command word following the alias is also
        # checked for alias expansion."
        sudo = "sudo -E ";
      };
    };
  };
}
