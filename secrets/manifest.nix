{
  secretsDir = "/run/agenix";
  systems = {
    argent = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcsCrdHED/c/hKwIMSIesma4n8+vC6pvRzM8+vUAwOh";
    nixos-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx6IjVdCOt+2w3E/nq3RWguMLbvetX1Bva2Zx7heFL0";
  };
  users = {
    desheffer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK78PLljlhmLf8HSyRqc97MSHxlXx3rqkY0uPG81iThH";
  };
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
