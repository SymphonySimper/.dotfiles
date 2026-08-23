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
    programs.helix = {
      lsp.ts_query_ls.command = lib.getExe pkgs.ts_query_ls;
    };
  };
}
