inputs@{ ... }:

{ username, initialPassword, modules, extraGroups ? [ ], ... }:

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

  home-manager.users.${username}.imports = [ ../modules ] ++ modules;
}
