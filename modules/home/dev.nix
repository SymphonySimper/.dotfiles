{
  config,
  pkgs,
  lib,
  ...
}:
let
  mkGuiFormatter =
    { command, args }:
    {
      formatter.external = {
        inherit command;
        arguments = args;
      };
    };

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

  mkVscodeLsp = lspName: rec {
    name = "vscode-${lspName}-language-server";
    cmd = name;
    pkg = pkgs.vscode-langservers-extracted;
  };

  lsps = {
    tailwind = rec {
      name = "tailwindcss-ls";
      cmd = "tailwindcss-language-server";
      pkg = pkgs.${cmd};
    };
    eslint = mkVscodeLsp "eslint";
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
              gui.language = onlyAttr "guiLanguage";
              gui.lsp = onlyAttr "guiLsp";
              gui.extensions = onlyList "extensions";
              packages = [ pkgs.nodePackages.prettier ] ++ (onlyList "editorPackages");
            };

            shell = {
              env = onlyAttr "env";
              path = onlyList "path";
            };
          };

          home.packages = onlyList "packages";
          programs = onlyAttr "programs";
        }
      )
      [
        {
          # Tree-Sitter
          editorPackages = [ pkgs.ts_query_ls ];
        }

        rec {
          # Just
          packages = [ pkgs.just ];
          extensions = [ "justfile" ];

          guiLanguage.just = mkGuiFormatter language.just.formatter;
          language.just.formatter = {
            command = "just";
            args = [ "--dump" ];
          };
        }

        {
          # Docker
          extensions = [ "dockerfile" ];
          editorPackages = [ pkgs.dockerfile-language-server ];
        }

        rec {
          # markup
          extensions = [ "toml" ];
          editorExtension = [pkgs.taplo];

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

          guiLanguage = builtins.mapAttrs (name: value: mkGuiFormatter value.formatter) language;
        }

        (
          let
            jsonLsp = mkVscodeLsp "json";
          in
          rec {
            # JSON
            editorPackages = [ jsonLsp.pkg ];

            lsp.${jsonLsp.name} = {
              command = jsonLsp.name;
              config.json = {
                validate.enable = true;
                schemas = (
                  builtins.map (schema: {
                    fileMatch = schema.file;
                    url = mkSchema schema.name;
                  }) config.my.programs.editor.schema.json
                );
              };
            };

            language = lib.genAttrs [ "json" "jsonc" ] (name: {
              formatter = mkPrettier name;
              language-servers = [ jsonLsp.name ];
            });

            guiLsp.${jsonLsp.name}.settings = lsp.${jsonLsp.name}.config;
            guiLanguage = builtins.mapAttrs (name: value: mkGuiFormatter value.formatter) language;
          }
        )

        {
          # Rust
          packages = with pkgs; [
            rustup
            sccache
          ];

          env.RUST_BACKTRACE = "1";

          lsp.rust-analyzer.config.check = "clippy";
          guiLsp.rust-analyzer.initialization_options.check = "clippy";
        }

        rec {
          # Python
          packages = with pkgs; [
            python3
            uv
          ];

          programs.uv = {
            enable = true;
            settings = {
              python-downloads = "never";
            };
          };

          extensions = [ "ruff" ];
          extensionPackages = [
            pkgs.pyright
            pkgs.ruff
          ];

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

          guiLanguage.python = mkGuiFormatter language.python.formatter;
        }

        {
          # Markdown
          extensions = [
            "markdown-oxide"
            "harper"
          ];
          editorPackages = [
            pkgs.markdown-oxide
            pkgs.harper
          ];

          lsp = {
            markdown-oxide.command = "markdown-oxide";

            harper-ls = {
              command = "harper-ls";
              args = [ "--stdio" ];
            };
          };

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
          editorPackages = [ lsps.tailwind.pkg ];

          lsp.${lsps.tailwind.name} = {
            command = lsps.tailwind.cmd;
            args = [ "--stdio" ];
          };
        }

        {
          # Eslint
          editorPackages = [ lsps.eslint.pkg ];
          lsp.${lsps.eslint.name}.command = lsps.eslint.cmd;
        }

        (
          let
            htmlLsp = mkVscodeLsp "html";
            cssLsp = mkVscodeLsp "css";
          in
          rec {

            # HTML
            extensions = [
              "html"
              "emmet"
            ];
            editorPackages = [
              htmlLsp.pkg
              cssLsp.pkg
            ];

            lsp.${htmlLsp.name}.command = htmlLsp.cmd;
            language.html = {
              language-servers = [
                htmlLsp.name
                lsps.tailwind.name
              ];
              formatter = mkPrettier "html";
            };
            guiLanguage.html = mkGuiFormatter language.html.formatter;

            # CSS
            lsp.${cssLsp.name}.command = cssLsp.cmd;
            language.css = {
              language-servers = [
                cssLsp.name
                lsps.tailwind.name
              ];
              formatter = mkPrettier "css";
            };
            guiLanguage.css = mkGuiFormatter language.css.formatter;
          }
        )

        rec {
          # JS / TS

          packages = with pkgs; [
            nodejs
            corepack
          ];
          editorPackages = [
            pkgs.typescript-language-server
          ];

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
                  lsps.eslint.name
                ]
                ++ (lib.optionals (lib.strings.hasSuffix "sx" name) [ lsps.tailwind.name ]);
              });

          guiLanguage = builtins.mapAttrs (name: value: mkGuiFormatter value.formatter) language;

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

        (
          let
            lspName = "svelteserver";
          in
          rec {
            # Svelte
            extensions = [ "svelte" ];
            editorPackages = [ pkgs.svelte-language-server ];

            lsp.${lspName} = {
              config.configuration = {
                svelte.plugin.svelte.defaultScriptLanguage = "ts";
              };
            };

            language.svelte = {
              language-servers = [
                lspName
                lsps.tailwind.name
                lsps.eslint.name
              ];
              formatter = mkPrettier "svelte";
              block-comment-tokens = {
                start = "<!--";
                end = "-->";
              };
            };

            guiLsp.svelte-language-server.initialization_options = lsp.${lspName}.config;
            guiLanguage.svelte = mkGuiFormatter language.svelte.formatter;

            ignore = [ ".svelte-kit" ];
          }
        )
      ]
  );
}
