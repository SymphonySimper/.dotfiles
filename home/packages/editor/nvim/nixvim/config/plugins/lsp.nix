{ myUtils, ... }:
{
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
          [
            { __raw = "vim.lsp.buf.signature_help"; }
            "gK"
            "n"
            "Signature Help"
          ]
          [
            { __raw = "vim.lsp.buf.signature_help"; }
            "<c-k>"
            "i"
            "Signature Help"
          ]
        ];
      };

      servers = {
        # Nix
        nil-ls = {
          enable = true;
          settings.nix.flake.autoArchive = true;
        };

        # lua
        lua-ls.enable = true;

        # bash
        bashls.enable = true;

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
            [
              "cva\\(([^)]*)\\)"
              "[\"'`]([^\"'`]*).*?[\"'`]"
            ]
            [
              "cx\\(([^)]*)\\)"
              "(?:'|\"|`)([^']*)(?:'|\"|`)"
            ]
            [
              "cn\\(([^)]*)\\)"
              "[\"'`]([^\"'`]*).*?[\"'`]"
            ]
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

        # Go
        gopls = {
          enable = true;
          settings = {
            gopls = {
              gofumpt = true;
              codelenses = {
                gc_details = false;
                generate = true;
                regenerate_cgo = true;
                run_govulncheck = true;
                test = true;
                tidy = true;
                upgrade_dependency = true;
                vendor = true;
              };
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
              analyses = {
                fieldalignment = true;
                nilness = true;
                unusedparams = true;
                unusedwrite = true;
                useany = true;
              };
              usePlaceholders = true;
              completeUnimported = true;
              staticcheck = true;
              directoryFilters = [
                "-.git"
                "-.vscode"
                "-.idea"
                "-.vscode-test"
                "-node_modules"
              ];
            };
          };
        };

      };
    };
    lsp-format = {
      enable = true;
    };
  };
}
