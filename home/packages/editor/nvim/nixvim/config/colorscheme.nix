{ userSettings, ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = userSettings.theme.flavor;
        background = {
          light = "latte";
          dark = "mocha";
        };
      };
    };
    opts = {
      background = if userSettings.theme.dark then "dark" else "light";
    };
  };
}
