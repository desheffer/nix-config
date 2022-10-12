inputs@{ ... }:

{ username, initialPassword, modules, extraGroups ? [ ], authorizedKeys ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        inherit initialPassword extraGroups;

        isNormalUser = true;
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = authorizedKeys;
      };
    })
  ];

  home-manager.users.${username}.imports = [ ../modules ] ++ modules;
}
