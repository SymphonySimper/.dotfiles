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
  imports = [
    (lib.modules.mkAliasOptionModule
      [ "my" "programs" "editor" "lsp" ]
      [ "programs" "helix" "languages" "language-server" ]
    )
  ];

  options.my.programs.editor = {
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
  };

  config = {
    my.programs.editor.ignore = builtins.concatLists [
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
        };

        keys = {
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
                b = ":sh ${lib.getExe pkgs.git} -C %{workspace_directory} blame -L %{cursor_line},%{cursor_line} $(realpath %{buffer_name})";
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
              };

              f = {
                "'" = "last_picker";
                b = "buffer_picker";
                d = "diagnostics_picker";
                D = "workspace_diagnostics_picker";
                e = "file_explorer";
                E = "file_explorer_in_current_buffer_directory";
                f = "file_picker";
                F = "file_picker_in_current_buffer_directory"; # prev: file_picker_in_current_directory
                g = "changed_file_picker";
                "/" = "global_search";
                j = "jumplist_picker";
                s = "symbol_picker";
                S = "workspace_symbol_picker";
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
        language = lib.attrsets.mapAttrsToList (name: value: { inherit name; } // value) (cfg.language);
      };
    };
  };
}
