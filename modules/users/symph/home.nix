{ ... }:
let
  user = import ./_shared.nix;
in
{
  home.username = user.name;

  desktop.wallpaper = ../../../static/images/wallpaper.png;
}
