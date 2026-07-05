{
  inputs,
  config,
  pkgs,
  lib,
  mkGetTheme,
  ...
}:
let
  mkPrettier = name: {
    command = lib.getExe pkgs.prettier;
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

  mkVscodeLsp = lang: rec {
    name = "vscode-${lang}-language-server";
    command = lib.getExe' pkgs.vscode-langservers-extracted name;
  };

  lsps = {
    harper = rec {
      name = "harper-ls";
      command = lib.getExe' pkgs.harper name;
    };
    emmet = {
      name = "emmet-language-server";
      command = lib.getExe pkgs.emmet-language-server;
    };
    tailwind = {
      name = "tailwindcss-ls";
      command = lib.getExe pkgs.tailwindcss-language-server;
    };
  };
in
{
  config = lib.mkMerge (
    map
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

            shell = onlyAttr "shell";
          };

          home.packages = onlyList "packages";
          programs = onlyAttr "programs";
        }
      )
      [
        { lsp.${lsps.harper.name}.command = lsps.harper.command; }
        { language.git-commit.language-servers = [ lsps.harper.name ]; }
        { lsp.ts_query_ls.command = lib.getExe pkgs.ts_query_ls; }
        { lsp.docker-langserver.command = lib.getExe pkgs.dockerfile-language-server; }
        { language.yaml.formatter = mkPrettier "yaml"; }

        rec {
          packages = [ pkgs.just ];

          language.just.formatter = {
            command = lib.getExe (builtins.elemAt packages 0);
            args = [ "--dump" ];
          };
        }

        rec {
          lsp.taplo.command = lib.getExe pkgs.taplo;

          language.toml.formatter = {
            command = lsp.taplo.command;
            args = [
              "format"
              "-"
            ];
          };
        }

        (
          let
            jsonLsp = mkVscodeLsp "json";
          in
          {
            lsp.${jsonLsp.name} = {
              command = jsonLsp.command;

              config.json = {
                validate.enable = true;

                schemas = (
                  map (schema: {
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
          }
        )

        (
          let
            rustup = pkgs.rustup;
          in
          {
            packages = [
              rustup
              pkgs.sccache
              pkgs.gcc
            ];

            shell.env.RUST_BACKTRACE = "1";

            lsp.rust-analyzer = {
              command = lib.getExe' rustup "rust-analyzer";
              config.check = "clippy";
            };
          }
        )

        rec {
          packages = [ pkgs.python3 ];

          programs.uv = {
            enable = true;
            settings = {
              python-downloads = "automatic";
            };
          };

          lsp = {
            ruff = {
              command = lib.getExe pkgs.ruff;
              args = [ "server" ];
            };

            ty = {
              command = lib.getExe pkgs.ty;
              args = [ "server" ];
            };
          };

          language.python = {
            language-servers = [
              "ruff"
              "ty"
            ];

            formatter = {
              command = lsp.ruff.command;
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
              "mpls"
              lsps.harper.name
            ];
          };

          lsp.mpls = {
            command = lib.getExe pkgs.mpls;
            args = [
              "--no-auto"
              "--enable-emoji"
              "--theme"
              (mkGetTheme { name = "%name%-%flavor%"; })
            ];
          };
        }

        {
          lsp = {
            ${lsps.emmet.name} = {
              command = lsps.emmet.command;
              args = [ "--stdio" ];
              config = { };
            };

            ${lsps.tailwind.name}.command = lsps.tailwind.command;
          };
        }

        (
          let
            htmlLsp = mkVscodeLsp "html";
            cssLsp = mkVscodeLsp "css";
          in
          {
            # HTML
            language.html = {
              formatter = mkPrettier "html";
              language-servers = [
                htmlLsp.name
                lsps.emmet.name
                lsps.tailwind.name
              ];
            };

            # CSS
            language.css = {
              formatter = mkPrettier "css";
              language-servers = [
                cssLsp.name
                lsps.tailwind.name
              ];
            };
          }
        )

        rec {
          packages = [
            pkgs.nodejs_24
            pkgs.corepack_24 # switch to corepack for nodejs >= 25
          ];

          shell.env.PNPM_HOME = "${config.xdg.dataHome}/pnpm";
          shell.path = [ shell.env.PNPM_HOME ];

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
                ++ (lib.optionals (lib.strings.hasSuffix "sx" name) [
                  lsps.emmet.name
                  lsps.tailwind.name
                ]);
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
            {
              name = "chrome-manifest";
              file = [ "manifest.json" ];
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
          lsp.svelteserver = {
            command = lib.getExe pkgs.svelte-language-server;
            config.configuration.svelte.plugin.svelte.defaultScriptLanguage = "ts";
          };

          language.svelte = {
            formatter = mkPrettier "svelte";

            language-servers = [
              "svelteserver"
              lsps.emmet.name
              lsps.tailwind.name
            ];

            block-comment-tokens = {
              start = "<!--";
              end = "-->";
            };
          };

          ignore = [ ".svelte-kit" ];
        }

        {
          packages = [
            pkgs.go
            pkgs.gotools
            pkgs.golangci-lint
          ];

          lsp = {
            gopls.command = lib.getExe pkgs.gopls;
            golangci-lint-lsp.command = lib.getExe pkgs.golangci-lint-langserver;
          };

          language.go = {
            formatter.command = lib.getExe' pkgs.gotools "goimports";
          };
        }
      ]
  );
}
