{ ... }: {
  programs.nixvim = {
    diagnostic.settings = {
      severity_sort = true;

      # Show diagnostics below the cursor's current line.
      virtual_text = false;
      virtual_lines.current_line = true;

      signs = {
        priority = 250; # Keep diagnostic colors above mini.diff's line-number highlights (199).

        text.__raw = ''
          {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          }
        '';

        numhl.__raw = ''
          {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
          }
        '';
      };
    };

    lsp = {
      codelens.enable = true;
      completion.enable = false; # handled by blink
      documentColor.enable = true;
      linkedEditingRange.enable = true;
    };

    plugins.lspconfig.enable = true;

    keymaps = [
      {
        action.__raw = "vim.diagnostic.open_float";
        key = "grd";
        mode = "n";
        options.desc = "Show diagnostic for current line";
      }
      {
        action = "<cmd>lsp restart<CR>";
        key = "grl";
        mode = "n";
        options.desc = "Restart LSPs";
      }
    ];
  };
}
