{ lib, ... }:
{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      inlayHints = false;
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
          [
            { __raw = "vim.diagnostic.open_float"; }
            "<leader>cd"
            "n"
            "Line Diagnostics"
          ]
        ];
      };

      servers = {
        # Nix
        nil_ls = {
          enable = true;
          settings.nix.flake.autoArchive = true;
        };

        # lua
        lua_ls.enable = true;

        # bash
        bashls.enable = true;

        # Rust
        rust_analyzer = {
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
        ts_ls.enable = true;
        ## HTML
        html.enable = true;
        ## JSON
        jsonls.enable = true;

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
  };
}
