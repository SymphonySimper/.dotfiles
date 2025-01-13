{ ... }:
{
  my.programs.nvim = {
    treesitter = [ "lua" ];
    lsp.lua_ls.enable = true; # lua
    formatter = {
      packages = [ "stylua" ];
      ft.lua = "stylua";
    };
  };
}
