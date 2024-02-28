{ config, pkgs, ... }:
{
  programs.neovim = {
    defaultEditor = true;
  };
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };

  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
  ];
}
