inputs@{ secrets, neovim-config, ... }:

{ username, modules, initialHashedPassword, extraGroups ? [ ], authorizedKeys ? [ ], ... }:

{
  imports = [
    ({ pkgs, ... }: {
      users.users.${username} = {
        inherit initialHashedPassword extraGroups;

        isNormalUser = true;

        useDefaultShell = false;
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = authorizedKeys;
      };
    })
  ];

  home-manager.users.${username}.imports = [
    ../modules

    neovim-config.hmModules.neovim

    secrets.nixosModules.home-manager.secrets
    ../modules/secrets.nix
  ]
  ++ modules;
}
