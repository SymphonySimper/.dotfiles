{ ... }: {
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        sources = {
          default = [
            "lsp"
            "path"
            "buffer"
          ];

          providers = {
            # limits it to current buffer
            buffer = {
              min_keyword_length = 2;
              opts.get_bufnrs.__raw = ''
                function()
                  return { vim.api.nvim_get_current_buf() }
                end
              '';
            };

            path.opts.max_entries = 10;
          };
        };

        completion = {
          list.max_items = 20;
          # Avoid an extra LSP request for auto-brackets; item-kind detection still works.
          accept.auto_brackets.semantic_token_resolution.enabled = false;
        };
      };
    };
  };
}
