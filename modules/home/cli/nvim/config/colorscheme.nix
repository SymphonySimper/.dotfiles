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
        integrations = {
          blink_cmp = true;
          gitsigns = true;
          harpoon = true;
          mini.enabled = true;
          treesitter = true;
          telescope.enabled = true;
        };
      };
    };
    opts = {
      background = if my.theme.dark then "dark" else "light";
    };
  };
}
