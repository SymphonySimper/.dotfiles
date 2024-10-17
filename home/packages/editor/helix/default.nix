{
  pkgs,
  lib,
  userSettings,
  # helix-flake,
  ...
}:
{
  config = lib.mkIf (userSettings.programs.editor == "helix") {
    programs.helix = {
      enable = true;
      # package = helix-flake.packages.${pkgs.system}.default;

      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          true-color = true;
          color-modes = true;
          auto-format = true;
          auto-save = true;
          bufferline = "always";
          scrolloff = 8;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            render = true;
          };
          lsp = {
            enable = true;
            display-inlay-hints = true;
          };
        };
      };

      extraPackages = with pkgs; [
        # Lsp
        ## svelte
        nodePackages_latest.svelte-language-server
        ## tailwind
        tailwindcss-language-server
        ## ts
        typescript
        nodePackages_latest.typescript-language-server
        ## python
        ruff-lsp
        pyright
      ];

      languages = {
        language = [
          {
            name = "svelte";
            auto-format = true;
            language-servers = [
              "svelteserver"
              "tailwindcss-ls"
            ];
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "svelte"
              ];
            };
          }

          {
            name = "html";
            language-servers = [
              "vscode-html-language-server"
              "tailwindcss-ls"
            ];
          }

          {
            name = "css";
            language-servers = [
              "vscode-css-language-server"
              "tailwindcss-ls"
            ];
          }

          {
            name = "jsx";
            language-servers = [
              "typescript-language-server"
              "tailwindcss-ls"
            ];
          }

          {
            name = "tsx";
            language-servers = [
              "typescript-language-server"
              "tailwindcss-ls"
            ];
          }

          {
            name = "python";
            roots = [ "pyproject.toml" ];
            language-servers = [
              "pyright"
              "ruff"
            ];
          }
        ];

        language-server = {
          rust-analyzer.config.check = {
            command = "clippy";
          };

          pyright = {
            command = "pyright-langserver";
            args = [ "--stdio" ];
          };

          ruff = {
            command = "ruff-lsp";
            config.settings.run = "onSave";
          };
        };
      };
    };
  };
}
