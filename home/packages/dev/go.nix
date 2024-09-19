{ pkgs, ... }:
{
  programs.go.enable = true;
  home.packages = [ pkgs.templ ];
}
