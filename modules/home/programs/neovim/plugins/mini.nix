{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.mini-nvim;
      type = "lua";
      config = ''
        require("mini.pairs").setup()
      '';
    }
  ];
}
