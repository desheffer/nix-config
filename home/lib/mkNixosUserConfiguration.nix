inputs@{ ... }:

{ username, passwordFile, homeConfig, extraGroups ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        # NOTE: Hashed passwords can be generated using `mkpasswd -m sha-512`.
        inherit passwordFile extraGroups;

        isNormalUser = true;
        shell = pkgs.zsh;
      };
    })
  ];

  home-manager.users.${username}.imports = [
    {
      config.homeConfig = homeConfig;
    }
    ../modules
  ];
}
