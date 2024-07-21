{ myUtils, ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        silent = true;

        lspBuf = {
          gd = "definition";
          gr = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
          "<leader>cr" = "rename";
          "<leader>ca" = "code_action";
        };

        extra = myUtils.mkKeymaps [
          [
            ":LspRestart<Enter>"
            "<leader>lr"
            "n"
            "Restart LSP"
          ]
          # [
          #   ":lua vim.lsp.buf.code_action()<Enter>"
          #   "<leader>ca"
          #   "n"
          #   "Code actions"
          # ]
        ];
      };

      servers = {
        # Nix
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixpkgs-fmt" ];
        };

        # Rust
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings = {
            checkOnSave = true;
            check = {
              command = "clippy";
            };
          };
        };

        # Svelte
        svelte = {
          enable = true;
          initOptions.svelte.plugin.svelte.defaultScriptLanguage = "ts";
        };

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

        # Typescript
        tsserver.enable = true;

        # HTML
        html.enable = true;

        # Python
        pyright.enable = true;
        ruff-lsp.enable = true;
      };
    };
    lsp-format = { enable = true; };
  };
}
