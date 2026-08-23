{ ... }:
let
  user = import ./_shared.nix;
in
{
  users.users.${user.name} = {
    description = user.description;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nix-is-cool";
  };
}
