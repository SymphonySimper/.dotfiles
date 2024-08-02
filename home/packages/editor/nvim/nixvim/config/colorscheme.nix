{ userSettings, ... }:
{
  programs.nixvim = {
    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = userSettings.theme.flavor;
      };
    };
  };
}
