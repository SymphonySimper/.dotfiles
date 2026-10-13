{ config, lib, ... }: {
  options.dev.tree-sitter = {
    enable = lib.mkEnableOption "Tree-sitter";
  };

  config = lib.mkIf config.dev.tree-sitter.enable {
    programs.nixvim = {
      lsp.servers.ts_query_ls.enable = true;
    };
  };
}
