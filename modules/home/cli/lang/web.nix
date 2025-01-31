{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [
      "html"

      "css"
      "scss"

      "javascript"
      "typescript"
      "svelte"
    ];

    lsp.servers = {
      svelte = {
        enable = true;
        initOptions.svelte.plugin.svelte.defaultScriptLanguage = "ts";
      };

      tailwindcss.enable = true;

      # Typescript
      ts_ls.enable = true;

      html.enable = true;
    };

    formatter = {
      packages = [
        pkgs.nodePackages.prettier
      ];

      ft = rec {
        javascript = "prettier";
        typescript = javascript;
        svelte = javascript;
        css = javascript;
        html = javascript;
      };
    };
  };
}
