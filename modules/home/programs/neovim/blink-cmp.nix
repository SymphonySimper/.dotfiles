{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.blink-cmp;
      type = "lua";
      config = ''
        require("blink.cmp").setup({})
      '';
    }
  ];
}
