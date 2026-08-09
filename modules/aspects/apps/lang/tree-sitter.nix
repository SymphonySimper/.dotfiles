{
  den.aspects.apps.lang.tree-sitter = {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {
        programs.helix.lsp = {
          ts_query_ls.command = lib.getExe pkgs.ts_query_ls;
        };
      };
  };
}
