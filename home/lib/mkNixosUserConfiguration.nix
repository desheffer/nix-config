inputs@{ ... }:

{ username, homeConfig, hashedPassword, extraGroups ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        # NOTE: A hashed password can be generated using `mkpasswd -m sha-512`.
        inherit hashedPassword extraGroups;

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
