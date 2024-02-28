{ config, pkgs, ... }:
{
  programs.neovim = {
    defaultEditor = true;
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
  ];
}
