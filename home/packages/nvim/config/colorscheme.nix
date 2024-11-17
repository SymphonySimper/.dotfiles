{ my, ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = my.theme.flavor;
        background = {
          light = "latte";
          dark = "mocha";
        };
      };
    };
    opts = {
      background = if my.theme.dark then "dark" else "light";
    };
  };
}
