{
  my,
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.editor;
in
{
  options.my.programs.editor = {
    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Global ignore patterns for editor.file-picker";
      default = [ ];
    };

    lsp = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Alias for languages.langauge-server";
      default = { };
    };

    language = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Alias for languages.langauge";
      default = { };
    };
  };

  config = {
    my.programs.editor =
      let
        mkPrettier = name: {
          command = "${lib.getExe pkgs.nodePackages.prettier}";
          args = [
            "--parser"
            name
          ];
        };
      in
      lib.mkMerge [
        {
          ignore = builtins.concatLists [
            [
              # general
              ".DS_Store"
              "build"

              # binary
              "**/*.exe"
              "**/*.zip"
              "**/*.parquet"
              ## media
              "**/*.png"
              "**/*.jp[e]?g"
              "**/*.web[pm]"
              ## doc
              "**/*.pdf"
              "**/*.epub"
              "**/*.odt"
              "**/*.doc[x]?"
              "**/*.calc"
              "**/*.xls[x]?"
              "**/*:Zone.Identifier"
            ]

            # Do not ignore
            [
              "!.github/"
              "!.env*"
            ]
          ];
        }

        {
          # Just
          language.just.formatter = {
            command = "${lib.getExe pkgs.just}";
            args = [ "--dump" ];
          };
        }

        {
          # Docker
          lsp.docker-langserver.command = "${lib.getExe pkgs.dockerfile-language-server-nodejs}";
        }

        {
          # markup
          language = {
            yaml.formatter = mkPrettier "yaml";

            toml.formatter = {
              command = "${lib.getExe pkgs.taplo}";
              args = [
                "format"
                "-"
              ];
            };
          };
        }

        {
          # JSON
          language.json.formatter = mkPrettier "json";
          language.jsonc.formatter = mkPrettier "jsonc";
        }

        {
          # Rust
          lsp.rust-analyzer.config.check = "clippy";
        }

        {
          # Python
          lsp = {
            ruff = {
              command = lib.getExe' pkgs.ruff "ruff";
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
              command = "${lib.getExe pkgs.ruff}";
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
          lsp.markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
          language.markdown.formatter = mkPrettier "markdown";
        }

        {
          # Tailwindcss
          lsp.tailwindcss-ls = {
            command = "${lib.getExe pkgs.tailwindcss-language-server}";
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

        {
          # JS / TS
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
                ] ++ (lib.optionals (lib.strings.hasSuffix "sx" name) [ "tailwindcss-ls" ]);
              });

          ignore = [
            "node_modules"
            "vite.config.js.timestamp-*"
            "vite.config.ts.timestamp-*"
          ];
        }

        {
          # Svelte
          lsp.svelteserver.command = "${lib.getExe pkgs.svelte-language-server}";
          language.svelte = {
            language-servers = [
              "svelteserver"
              "tailwindcss-ls"
            ];
            formatter = mkPrettier "svelte";
          };

          ignore = [ ".svelte-kit" ];
        }
      ];

    xdg.configFile."helix/ignore".text = builtins.concatStringsSep "\n" (lib.lists.unique cfg.ignore);

    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${my.system}.default;
      defaultEditor = true;

      settings = {
        editor = {
          line-number = "relative";
          auto-format = false;
          bufferline = "never";
          auto-pairs = true;
          true-color = my.profile == "wsl";
          indent-guides.render = false;
          soft-wrap.enable = true;

          cursor-shape = rec {
            normal = "block";
            insert = "bar";
            select = normal;
          };

          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "warning";
          lsp = {
            enable = true;
            display-inlay-hints = false;
            auto-signature-help = false;
            display-color-swatches = false;
          };
        };

        keys = {
          normal = {
            space = {
              b = {
                c = ":bc";
                w = ":w";
                r = ":reload";
                R = ":reload-all";
              };

              c = {
                c = "toggle_comments";
                C = "toggle_block_comments";
                f = ":format";
                a = "code_action";
                r = "rename_symbol";
                l = ":lsp-restart";
                h = "select_references_to_symbol_under_cursor";
                b = ":sh ${lib.getExe pkgs.git} -C $(dirname $(realpath %{buffer_name})) blame -L %{cursor_line},%{cursor_line} $(realpath %{buffer_name})";
                s = "signature_help";
                y = ":yank-diagnostic";
              };

              f = {
                "'" = "last_picker";
                f = "file_picker";
                F = "file_picker_in_current_buffer_directory"; # prev: file_picker_in_current_directory
                b = "buffer_picker";
                j = "jumplist_picker";
                g = "changed_file_picker";
                s = "symbol_picker";
                S = "workspace_symbol_picker";
                d = "diagnostics_picker";
                D = "workspace_diagnostics_picker";
                "/" = "global_search";
                y = ":sh ${lib.getExe pkgs.tmux} new-window ${lib.getExe' pkgs.yazi "yazi"} $(realpath %{buffer_name}) ";
              };

              q = ":quit";
            };
          };

          insert = {
            C-p = "signature_help";
          };
        };
      };

      languages = {
        language-server = cfg.lsp;
        language = lib.attrsets.mapAttrsToList (name: value: { inherit name; } // value) (cfg.language);
      };
    };
  };
}
