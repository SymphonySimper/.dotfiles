{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bun
    nodejs
    corepack
    # nodePackages_latest.npm
    # nodePackages_latest.pnpm
  ];
}
