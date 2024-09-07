{ config, ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = config.my.theme.flavor;
        background = {
          light = "latte";
          dark = "mocha";
        };
      };
    };
    opts = {
      background = if config.my.theme.dark then "dark" else "light";
    };
  };
}
