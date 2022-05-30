inputs@{ ... }:
{ username, roles, hashedPassword, extraGroups ? [ ], ... }:
  {
    users.users.${username} = {
      # NOTE: A hashed password can be generated using `mkpasswd -m sha-512`.
      inherit hashedPassword extraGroups;

      isNormalUser = true;
    };

    home-manager.users.${username}.imports = [
      {
        config.userRoles = roles;
      }
      ../home-manager
    ];
  }
