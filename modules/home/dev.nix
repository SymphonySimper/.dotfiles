{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  mkPrettier = name: {
    command = lib.getExe pkgs.nodePackages.prettier;
    args = [
      "--parser"
      name
    ];
  };

  # refer:  https://www.schemastore.org/
  mkSchema =
    name:
    if (lib.strings.hasInfix "/" name) then
      name
    else
      "${inputs.schemastore}/src/schemas/json/${name}.json";

  mkVscodeLsp =
    name:
    let
      fullName = "vscode-${name}-language-server";
    in
    {
      name = fullName;
      cmd = lib.getExe' pkgs.vscode-langservers-extracted fullName;
    };

  lsps = {
    tailwind = {
      name = "tailwindcss-ls";
      cmd = lib.getExe pkgs.tailwindcss-language-server;
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
          lsp.ts_query_ls.command = lib.getExe pkgs.ts_query_ls;
        }

        {
          # Just
          packages = [ pkgs.just ];

          language.just.formatter = {
            command = lib.getExe pkgs.just;
            args = [ "--dump" ];
          };
        }

        {
          # Docker
          lsp.docker-langserver.command = lib.getExe pkgs.dockerfile-language-server;
        }

        {
          # markup
          language = {
            yaml.formatter = mkPrettier "yaml";

            toml.formatter = {
              command = lib.getExe pkgs.taplo;
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
            lsp = {
              biome = {
                command = lib.getExe pkgs.biome;
                args = [ "lsp-proxy" ];
              };

              ${jsonLsp.name} = {
                command = jsonLsp.cmd;
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
            };

            language = lib.genAttrs [ "json" "jsonc" ] (name: {
              formatter = mkPrettier name;
              language-servers = [
                {
                  name = jsonLsp.name;
                  only-features = [
                    "completion"
                    "hover"
                  ];
                }
                {
                  name = "biome";
                  only-features = [ "diagnostics" ];
                }
              ];
            });
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
        }

        {
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

          # NOTE: Switching until ty or ruff impletements goto feature
          lsp = {
            pyright = {
              command = lib.getExe' pkgs.pyright "pyright-langserver";
              config.python.analysis.typeCheckingMode = "basic";
            };

            ruff = {
              command = lib.getExe' pkgs.ruff "ruff";
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
              command = lib.getExe pkgs.ruff;
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
          lsp = {
            markdown-oxide.command = lib.getExe pkgs.markdown-oxide;

            harper-ls = {
              command = lib.getExe pkgs.harper;
              args = [ "--stdio" ];
            };
          };

          language.markdown = {
            formatter = mkPrettier "markdown";

            language-servers = [
              "markdown-oxide"
              "harper-ls"
            ];
          };
        }

        {
          # Tailwindcss
          lsp.${lsps.tailwind.name} = {
            command = lsps.tailwind.cmd;
            args = [ "--stdio" ];
          };
        }

        {
          # Eslint
          lsp.${lsps.eslint.name}.command = lsps.eslint.cmd;
        }

        (
          let
            htmlLsp = mkVscodeLsp "html";
            cssLsp = mkVscodeLsp "css";
          in
          {
            # HTML
            lsp.${htmlLsp.name}.command = htmlLsp.cmd;
            language.html = {
              language-servers = [
                htmlLsp.name
                lsps.tailwind.name
              ];
              formatter = mkPrettier "html";
            };

            # CSS
            lsp.${cssLsp.name}.command = cssLsp.cmd;
            language.css = {
              language-servers = [
                cssLsp.name
                lsps.tailwind.name
              ];
              formatter = mkPrettier "css";
            };
          }
        )

        rec {
          # JS / TS

          packages = with pkgs; [
            nodejs
            corepack
          ];

          env.PNPM_HOME = "${config.xdg.dataHome}/pnpm";
          path = [ env.PNPM_HOME ];

          lsp.typescript-language-server.command = lib.getExe pkgs.typescript-language-server;

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
          lsp.svelteserver = {
            command = lib.getExe pkgs.svelte-language-server;
            config.configuration = {
              svelte.plugin.svelte.defaultScriptLanguage = "ts";
            };
          };

          language.svelte = {
            language-servers = [
              "svelteserver"
              lsps.tailwind.name
              lsps.eslint.name
            ];
            formatter = mkPrettier "svelte";
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
