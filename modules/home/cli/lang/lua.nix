{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "lua" ];

    conform-nvim = {
      formatter.stylua = pkgs.stylua;
      settings.formatters_by_ft.lua = [ "stylua" ];
    };

    lsp.servers.lua_ls.enable = true;
  };
}
