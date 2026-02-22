inputs@{ secrets, neovim-config, ... }:

{
  username,
  modules,
  initialHashedPassword,
  avatar,
  extraGroups ? [ ],
  authorizedKeys ? [ ],
  ...
}:

{
  imports = [
    (
      { pkgs, ... }:
      {
        users.users.${username} = {
          inherit initialHashedPassword extraGroups;

          isNormalUser = true;

          useDefaultShell = false;
          shell = pkgs.zsh;

          openssh.authorizedKeys.keys = authorizedKeys;
        };

        systemd.tmpfiles.rules = [
          "L+ /var/lib/AccountsService/icons/${username} 0444 root root - ${pkgs.gnome-control-center}/share/pixmaps/faces/${avatar}"
          "f+ /var/lib/AccountsService/users/${username} 0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${username}\\n"
        ];
      }
    )
  ];

  home-manager.users.${username}.imports = [
    ../modules

    neovim-config.homeManagerModules.neovim

    secrets.homeManagerModules.secrets
    ../modules/secrets.nix
  ]
  ++ modules;
}
