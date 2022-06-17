inputs@{ ... }:

{ username, initialPassword, homeConfig, extraGroups ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        inherit initialPassword extraGroups;

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
