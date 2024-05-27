{ ... }: {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      keymaps = {
        silent = true;

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
            action = ":LspRestart<Enter>";
            key = "<leader>lr";
            options.desc = "Restart LSP";
          }
        ];
      };

      servers = {
        # Nix
        nixd = {
          enable = true;
          settings.formatting.command = [ "nixpkgs-fmt" ];
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
