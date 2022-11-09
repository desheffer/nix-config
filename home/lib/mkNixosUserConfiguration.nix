inputs@{ secrets, ... }:

{ username, modules, extraGroups ? [ ], authorizedKeys ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        inherit extraGroups;

        initialPassword = username;
        isNormalUser = true;

        useDefaultShell = false;
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = authorizedKeys;
      };
    })
  ];

  home-manager.users.${username}.imports = [
    ../modules

    secrets.nixosModules.home-manager
  ]
  ++ modules;
}
