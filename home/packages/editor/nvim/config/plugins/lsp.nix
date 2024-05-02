{ ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };

        lspBuf = {
          gd = "definition";
          gr = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
          "<leader>cr" = "rename";
        };
        extra = [
          {
            action = "<CMD>LspRestart<Enter>";
            key = "<leader>lr";
            options.desc = "Restart LSP";
          }
        ];
      };

      servers = {
        # Nix
        nixd = {
          enable = true;
          settings.formatting.command = "nixpkgs-fmt";
        };

        # Svelte
        svelte.enable = true;

        # Tailwind
        tailwindcss = {
          enable = true;
          settings.tailwindCSS.experimental.classRegex = [
            # Refer: https://github.com/paolotiu/tailwind-intellisense-regex-list
            [ "cva\\(([^)]*)\\)" "[\"'`]([^\"'`]*).*?[\"'`]" ]
            [ "cx\\(([^)]*)\\)" "(?:'|\"|`)([^']*)(?:'|\"|`)" ]
            [ "cn\\(([^)]*)\\)" "[\"'`]([^\"'`]*).*?[\"'`]" ]
            # [ "([a-zA-Z0-9\\-:]+)" ]
          ];
        };
      };
    };
    lsp-format = { enable = true; };
  };
}
