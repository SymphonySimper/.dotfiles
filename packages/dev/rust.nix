{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    sccache
  ];
}