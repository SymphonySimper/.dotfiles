{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.tree-sitter = {
    enable = lib.mkEnableOption "Tree-sitter";
  };

  config = lib.mkIf config.dev.tree-sitter.enable {
    programs.neovim = {
      extraPackages = [ pkgs.ts_query_ls ];
      config.lsp = ''vim.lsp.enable("ts_query_ls")'';
    };
  };
}
