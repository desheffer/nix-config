{
  description = "Placeholder for Doug's Secrets";

  outputs = inputs: {
    nixosModules = {
      secrets = { lib, ... }: {
        options.secrets.enable = lib.mkEnableOption "secrets";

        options.age.identityPaths = lib.mkOption { type = lib.types.listOf lib.types.str; };
      };

      passwords = {
        desheffer = "!";
        upsmon = "placeholder";
      };

      keys = {
        users = {
          desheffer = "ssh-ed25519 placeholder";
        };
      };
    };

    homeManagerModules.secrets = { lib, ... }: {
      options.secrets.enable = lib.mkEnableOption "secrets";
    };
  };
}
