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
          my.programs.editor = {
            language = onlyAttr "language";
            lsp = onlyAttr "lsp";
            schema = onlyAttr "schema";
            ignore = onlyList "ignore";
          };

          home = {
            packages = onlyList "packages";
            sessionVariables = onlyAttr "env";
            sessionPath = onlyList "path";
          };

          programs = onlyAttr "programs";
        }
      )
      [
        {
          # Work
          packages = [ pkgs.google-cloud-sdk ];
          env.GOOGLE_APPLICATION_CREDENTIALS = "${config.xdg.configHome}/gcloud/application_default_credentials.json";
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
          lsp.docker-langserver.command = lib.getExe pkgs.dockerfile-language-server-nodejs;
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
            vsLsp = "vscode-json-language-server";
          in
          {
            # JSON
            lsp = {
              biome = {
                command = lib.getExe pkgs.biome;
                args = [ "lsp-proxy" ];
              };

              ${vsLsp} = {
                command = lib.getExe' pkgs.vscode-langservers-extracted vsLsp;
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
                  name = vsLsp;
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
            python3Full
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
          lsp.tailwindcss-ls = {
            command = lib.getExe pkgs.tailwindcss-language-server;
            args = [ "--stdio" ];
          };
        }

        {
          # HTML
          lsp.vscode-html-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
          language.html = {
            language-servers = [
              "vscode-html-language-server"
              "tailwindcss-ls"
            ];
            formatter = mkPrettier "html";
          };

          # CSS
          lsp.vscode-css-language-server.command = lib.getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
          language.css = {
            language-servers = [
              "vscode-css-language-server"
              "tailwindcss-ls"
            ];
            formatter = mkPrettier "css";
          };
        }

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
                ]
                ++ (lib.optionals (lib.strings.hasSuffix "sx" name) [ "tailwindcss-ls" ]);
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
          lsp.svelteserver.command = lib.getExe pkgs.svelte-language-server;
          language.svelte = {
            language-servers = [
              "svelteserver"
              "tailwindcss-ls"
            ];
            formatter = mkPrettier "svelte";
          };

          ignore = [ ".svelte-kit" ];
        }
      ]
  );
}
