{
  my,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.editor;
in
{
  imports = [
    (lib.modules.mkAliasOptionModule
      [ "my" "programs" "editor" "lsp" ]
      [ "programs" "helix" "languages" "language-server" ]
    )
  ];

  options.my.programs.editor = (lib.my.mkNameOption "Editor" "hx") // {
    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Global ignore patterns for editor.file-picker";
      default = [ ];
    };

    language = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Alias for languages.langauge";
      default = { };
    };

    schema = (
      lib.genAttrs [ "json" ] (
        lang:
        lib.mkOption {
          description = "Schema for completion support from LSP";

          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name / URL of Schema";
                };

                file = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  description = "File patterns";
                };
              };
            }
          );

          default = [ ];
        }
      )
    );

    clipboardProvider = lib.mkOption {
      # refer: https://docs.helix-editor.com/editor.html?highlight=clipboard#editorclipboard-provider-section
      type = lib.types.nullOr (
        lib.types.oneOf [
          (
            let
              mkClipboardOption =
                action:
                lib.mkOption {
                  type = lib.types.submodule {
                    options = {
                      command = lib.mkOption {
                        type = lib.types.str;
                        description = "${action} command";
                      };

                      args = lib.mkOption {
                        type = lib.types.listOf lib.types.str;
                        description = "${action} command args";
                      };
                    };
                  };
                  description = "${action} provider options";
                };
            in
            lib.types.submodule {
              options = {
                yank = mkClipboardOption "Yank";
                paste = mkClipboardOption "Paste";
              };
            }
          )

          (lib.types.enum [
            "pasteboard" # MacOS
            "wayland"
            "x-clip"
            "x-sel"
            "win32-yank"
            "termux"
            "tmux"
            "windows"
            "termcode"
            "none"
          ])
        ]

      );
      description = "clipboard-provider";
      default = null;
    };
  };

  config = {
    my.programs = {
      editor.ignore = builtins.concatLists [
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
    };

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

          auto-completion = true;
          path-completion = true;
          preview-completion-insert = true;
          completion-replace = true;
          word-completion = {
            enable = true;
            trigger-length = 4;
          };

          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "warning";
          lsp = {
            enable = true;
            display-inlay-hints = false;
            auto-signature-help = false;
            display-color-swatches = false;
          };

          clipboard-provider = lib.mkIf (cfg.clipboardProvider != null) (
            if (builtins.typeOf cfg.clipboardProvider == "string") then
              cfg.clipboardProvider
            else
              {
                custom = cfg.clipboardProvider;
              }
          );
        };

        keys = rec {
          normal = {
            space = {
              b = {
                c = ":bc";
                r = ":reload";
                R = ":reload-all";
                w = ":w";
              };

              c = {
                a = "code_action";
                b = ":sh git -C %{workspace_directory} blame -L %{cursor_line},%{cursor_line} $(realpath %{buffer_name})";
                C = "toggle_block_comments";
                c = "toggle_comments";
                f = ":format";
                h = "select_references_to_symbol_under_cursor";
                I = "decrement";
                i = "increment";
                l = ":lsp-restart";
                r = "rename_symbol";
                s = "signature_help";
                y = ":yank-diagnostic";

                t = {
                  s = ":tree-sitter-scopes";
                  h = ":tree-sitter-highlight-name";
                  t = ":tree-sitter-subtree";
                  T = [
                    "select_all"
                    ":tree-sitter-subtree"
                  ];
                };
              };

              f = {
                "'" = "last_picker";
                b = "buffer_picker";
                B = {
                  e = "file_explorer_in_current_buffer_directory";
                  f = "file_picker_in_current_buffer_directory";
                };
                d = "diagnostics_picker";
                D = "workspace_diagnostics_picker";
                e = "file_explorer_in_current_directory";
                E = "file_explorer";
                f = "file_picker_in_current_directory";
                F = "file_picker";
                g = "changed_file_picker";
                "/" = "global_search";
                j = "jumplist_picker";
                s = "symbol_picker";
                S = "workspace_symbol_picker";
              };

              # macros
              m = {
                ## add xml like tag with the closing tag
                t = "@o<esc>|printf<space>'<lt>xxx<gt>\n<lt>/xxx<gt>\n'<ret>sxxx<ret>c";
              };

              q = ":quit";
            };
          };

          select = normal;

          insert = {
            C-p = "signature_help";
          };
        };
      };

      languages = {
        language = lib.attrsets.mapAttrsToList (name: value: { inherit name; } // value) (cfg.language);
      };
    };
  };
}
