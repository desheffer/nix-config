{ lib, ... }:

with lib;

{
  age.secrets = {
    deshefferPassword.file = ../../secrets/deshefferPassword.age;
  };
}
