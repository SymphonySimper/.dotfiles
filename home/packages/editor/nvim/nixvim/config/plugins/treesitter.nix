{ ... }: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;
      settings = {
        indent.enable = true;
        ensure_installed = [
          "astro"
          "bash"
          "css"
          "gitcommit"
          "gitignore"
          "html"
          "javascript"
          "jsdoc"
          "json"
          "lua"
          "markdown"
          "python"
          "regex"
          "scss"
          "svelte"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];
      };
    };

    ts-autotag.enable = true;
    ts-context-commentstring.enable = true;
  };
}
