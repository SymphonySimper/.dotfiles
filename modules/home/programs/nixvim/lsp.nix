{ ... }: {
  programs.nixvim = {
    lsp = {
      codelens.enable = true;
      completion.enable = false; # handled by blink
      documentColor.enable = true;
      linkedEditingRange.enable = true;
    };

    plugins.lspconfig.enable = true;

    keymaps = [
      {
        action.__raw = "vim.lsp.buf.code_action";
        key = "<leader>ca";
        mode = [
          "n"
          "x"
        ];
        options.desc = "LSP Code Actions";
      }
      {
        action.__raw = "vim.diagnostic.open_float";
        key = "<leader>cd";
        options.desc = "Show diagnostic for current line";
      }
      {
        action = "<cmd>lsp restart<CR>";
        key = "<leader>cl";
        options.desc = "Restart LSPs";
      }
    ];
  };
}
