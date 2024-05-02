{ ... }: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    indent = true;
    nixvimInjections = true;
    ensureInstalled = [
      "astro"
      "bash"
      "c"
      "css"
      "devicetree"
      "gitcommit"
      "gitignore"
      "html"
      "javascript"
      "jsdoc"
      "json"
      "lua"
      "luadoc"
      "luap"
      "markdown"
      "markdown_inline"
      "python"
      "query"
      "regex"
      "scss"
      "svelte"
      "tsx"
      "typescript"
      "vim"
      "vimdoc"
      "vue"
      "yaml"
    ];
  };
}
