{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkPrettier = name: {
    command = "prettier";
    args = [
      "--parser"
      name
    ];
  };

  # refer:  https://www.schemastore.org/
  mkSchema =
    name: if (lib.strings.hasInfix "/" name) then name else "https://www.schemastore.org/${name}.json";

  mkVscodeLsp = name: "vscode-${name}-language-server";

  lsps = {
    tailwind = "tailwindcss-ls";
  };
in
{
  config = lib.mkMerge (
    builtins.map
      (
        lang:
        let
          only = func: key: func (builtins.hasAttr key lang) lang.${key};
          onlyAttr = key: only lib.attrsets.optionalAttrs key;
          onlyList = key: only lib.lists.optionals key;
        in
        {
          my.programs = {
            editor = {
              language = onlyAttr "language";
              lsp = onlyAttr "lsp";
              schema = onlyAttr "schema";
              ignore = onlyList "ignore";
              packages = [
                pkgs.nodePackages.prettier
                pkgs.vscode-langservers-extracted
              ]
              ++ (onlyList "packages");
            };

            shell = {
              env = onlyAttr "env";
              path = onlyList "path";
            };
          };

          home.packages = onlyList "homePackages";
          programs = onlyAttr "programs";
        }
      )
      [
        {
          # Tree-Sitter
          packages = [ pkgs.ts_query_ls ];
        }

        {
          # Just
          homePackages = [ pkgs.just ];

          language.just.formatter = {
            command = "just";
            args = [ "--dump" ];
          };
        }

        {
          # Docker
          packages = [ pkgs.dockerfile-language-server ];
        }

        {
          # markup
          packages = [ pkgs.taplo ];

          language = {
            yaml.formatter = mkPrettier "yaml";

            toml.formatter = {
              command = "taplo";
              args = [
                "format"
                "-"
              ];
            };
          };
        }

        (
          let
            jsonLsp = mkVscodeLsp "json";
          in
          {
            # JSON
            lsp.${jsonLsp}.config.json = {
              validate.enable = true;

              schemas = (
                builtins.map (schema: {
                  fileMatch = schema.file;
                  url = mkSchema schema.name;
                }) config.my.programs.editor.schema.json
              );
            };

            language = lib.genAttrs [ "json" "jsonc" ] (name: {
              formatter = mkPrettier name;
              language-servers = [ jsonLsp ];
            });
          }
        )

        {
          # Rust
          homePackages = with pkgs; [
            rustup
            sccache
            gcc
          ];

          env.RUST_BACKTRACE = "1";
          lsp.rust-analyzer.config.check = "clippy";
        }

        {
          # Python
          homePackages = with pkgs; [
            python3
            uv
          ];

          packages = [
            pkgs.ruff
            pkgs.pyright
          ];

          programs.uv = {
            enable = true;
            settings = {
              python-downloads = "never";
            };
          };

          # NOTE: Switching until ty or ruff impletements goto feature
          lsp = {
            pyright = {
              command = "pyright-langserver";
              config.python.analysis.typeCheckingMode = "basic";
            };

            ruff = {
              command = "ruff";
              args = [ "server" ];
            };

            # ty = {
            #   command = lib.getExe pkgs.ty;
            #   args = [ "server" ];
            # };
          };

          language.python = {
            language-servers = [
              "pyright"
              "ruff"
              # "ty"
            ];

            formatter = {
              command = "ruff";
              args = [
                "format"
                "--line-length"
                "88"
                "-"
              ];
            };
          };

          ignore = [
            ".venv"
            "venv"
            "**/__pycache__/"
          ];
        }

        {
          # Markdown
          packages = [
            pkgs.markdown-oxide
            pkgs.harper
          ];

          language.markdown = {
            # refer: https://github.com/helix-editor/helix/wiki/Recipes#continue-markdown-lists--quotes
            comment-tokens = [
              "-"
              "+"
              "*"
              "- [ ]"
              ">"
            ];
            formatter = mkPrettier "markdown";

            language-servers = [
              "markdown-oxide"
              "harper-ls"
            ];
          };
        }

        {
          # Tailwindcss
          packages = [ pkgs.tailwindcss-language-server ];
        }

        (
          let
            htmlLsp = mkVscodeLsp "html";
            cssLsp = mkVscodeLsp "css";
          in
          {
            # HTML
            language.html = {
              language-servers = [
                htmlLsp
                lsps.tailwind
              ];
              formatter = mkPrettier "html";
            };

            # CSS
            language.css = {
              language-servers = [
                cssLsp
                lsps.tailwind
              ];
              formatter = mkPrettier "css";
            };
          }
        )

        rec {
          # JS / TS
          homePackages = [
            pkgs.nodejs_24
            pkgs.corepack_24 # switch to corepack for nodejs >= 25
          ];

          packages = [ pkgs.typescript-language-server ];

          env.PNPM_HOME = "${config.xdg.dataHome}/pnpm";
          path = [ env.PNPM_HOME ];

          language =
            lib.attrsets.genAttrs
              [
                "javascript"
                "jsx"

                "typescript"
                "tsx"
              ]
              (name: {
                formatter = mkPrettier "typescript";
                language-servers = [
                  "typescript-language-server"
                ]
                ++ (lib.optionals (lib.strings.hasSuffix "sx" name) [ lsps.tailwind ]);
              });

          schema.json = [
            {
              name = "package";
              file = [ "package.json" ];
            }
            {
              name = "tsconfig";
              file = [
                "tsconfig.json"
                "tsconfig.*.json"
              ];
            }
          ];

          ignore = [
            "node_modules"
            "vite.config.js.timestamp-*"
            "vite.config.ts.timestamp-*"

            "!*prettier*"
            "!.npmrc"
          ];
        }

        {
          # Svelte
          packages = [ pkgs.svelte-language-server ];

          lsp.svelteserver.config.configuration.svelte.plugin.svelte.defaultScriptLanguage = "ts";

          language.svelte = {
            formatter = mkPrettier "svelte";

            language-servers = [
              "svelteserver"
              lsps.tailwind
            ];

            block-comment-tokens = {
              start = "<!--";
              end = "-->";
            };
          };

          ignore = [ ".svelte-kit" ];
        }
      ]
  );
}
