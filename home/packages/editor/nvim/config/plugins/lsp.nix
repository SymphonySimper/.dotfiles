{ lib, ... }:
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

        extra = lib.my.mkKeymaps [
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

        # Web
        ## Svelte
        svelte = {
          enable = true;
          initOptions.svelte.plugin.svelte.defaultScriptLanguage = "ts";
        };
        ## Tailwind
        tailwindcss.enable = true;
        ## Typescript
        tsserver.enable = true;
        ## HTML
        html.enable = true;

        # Python
        pyright.enable = true;
        ruff.enable = true;

        # Markdown
        marksman.enable = true;

        # GO
        gopls = {
          enable = true;
          settings = {
            gopls = {
              completeUnimported = true;
            };

          };
        };
        templ.enable = true;
      };
    };
    lsp-format = {
      enable = true;
    };
  };
}
