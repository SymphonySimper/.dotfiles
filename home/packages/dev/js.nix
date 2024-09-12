{ pkgs, ... }:
{
  home.packages = with pkgs; [
    biome
    bun
    corepack
    nodejs
    # nodePackages_latest.npm
    # nodePackages_latest.pnpm
  ];
}
