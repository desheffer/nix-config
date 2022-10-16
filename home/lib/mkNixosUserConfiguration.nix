inputs@{ ... }:

{ username, modules, extraGroups ? [ ], authorizedKeys ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        inherit extraGroups;

        initialPassword = username;
        isNormalUser = true;
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = authorizedKeys;
      };
    })
  ];

  home-manager.users.${username}.imports = [ ../modules ] ++ modules;
}
