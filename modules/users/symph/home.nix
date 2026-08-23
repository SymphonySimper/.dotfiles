{ ... }:
let
  user = import ./_shared.nix;
in
{
  home.username = user.name;
}
