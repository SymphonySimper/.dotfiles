{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bun
    nodejs
    nodePackages_latest.npm
    nodePackages_latest.pnpm
  ];
}
