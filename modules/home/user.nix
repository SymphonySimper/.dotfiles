{ pkgs, config, ... }:
let
  homeRoot = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
in
{
  home.homeDirectory = "${homeRoot}/${config.home.username}";
}
