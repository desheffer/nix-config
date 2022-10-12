{
  secretsDir = "/run/agenix";
  files = {
    "desheffer/.aws/config" = {
      owner = "desheffer";
      target = ".aws/config";
    };
    "desheffer/.aws/credentials" = {
      owner = "desheffer";
      target = ".aws/credentials";
    };
    "desheffer/.config/composer/auth.json" = {
      owner = "desheffer";
      target = ".config/composer/auth.json";
    };
    "desheffer/.config/docker/config.json" = {
      owner = "desheffer";
      target = ".config/docker/config.json";
    };
    "desheffer/.config/heimdallr/config.toml" = {
      owner = "desheffer";
      target = ".config/heimdallr/config.toml";
    };
    "desheffer/.rs/aws" = {
      owner = "desheffer";
      target = ".rs/aws";
    };
    "desheffer/.rs/google-auth.json" = {
      owner = "desheffer";
      target = ".rs/google-auth.json";
    };
    "desheffer/.rs/whoami" = {
      owner = "desheffer";
      target = ".rs/whoami";
    };
    "desheffer/.rs/whoamidb" = {
      owner = "desheffer";
      target = ".rs/whoamidb";
    };
    "desheffer/.ssh/config" = {
      owner = "desheffer";
      target = ".ssh/config";
    };
    "desheffer/.ssh/id_ed25519" = {
      owner = "desheffer";
      target = ".ssh/id_ed25519";
    };
  };
}
