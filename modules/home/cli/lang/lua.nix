{ ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "lua" ];

    lsp.servers.lua_ls.enable = true; # lua

    formatter = {
      packages = [ "stylua" ];
      ft.lua = "stylua";
    };
  };
}
