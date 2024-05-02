{ ... }: {
  programs.nixvim.plugins =
    {
      luasnip.enable = true;

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "path"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            {
              name = "buffer";
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
          ];
          mapping = {
            "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
            "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-y>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };

      cmp-async-path.enable = true;
    };
}
