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
    (lib.modules.mkAliasOptionModule
      [ "my" "programs" "editor" "extensions" ]
      [ "programs" "zed-editor" "extensions" ]
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

    catppuccin.zed.enable = false;
    programs.zed-editor = {
      enable = my.gui.enable;

      extensions = [
        "catppuccin"
        "catppuccin-icons"
      ];

      userSettings = rec {
        disable_ai = true;

        # font
        buffer_font_family = my.theme.font.mono;
        ui_font_size = 16;
        buffer_font_size = 15;

        theme = {
          mode = "system";
          light = "Catppuccin ${lib.strings.toSentenceCase my.theme.flavors.light}";
          dark = "Catppuccin ${lib.strings.toSentenceCase my.theme.flavors.dark}";
        };
        icon_theme = theme;

        title_bar = {
          show_branch_icon = true;
          show_branch_name = true;
          show_sign_in = false;
        };
        tab_bar.show = false;
        minimap.show = "never";

        scroll_beyond_last_line = "one_page";
        vertical_scroll_margin = 5;
        horizontal_scroll_margin = vertical_scroll_margin;

        cursor_blink = false;
        cursor_shape = "block";
        current_line_highlight = "all";

        soft_wrap = "editor_width";
        preferred_line_length = 80;
        show_wrap_guides = true;
        relative_line_numbers = true;

        tab_size = 2;

        format_on_save = "off";
        ensure_final_newline_on_save = true;
        use_autoclose = true;
        use_auto_surround = true;

        file_finder.include_ignored = true;

        # panels
        collaboration_panel.button = false;

        # search
        search.regex = true;
        use_smartcase_search = true;
        seed_search_query_from_cursor = "selection";

        # lsp
        enable_language_server = true;
        inlay_hints.enabled = false;
        auto_signature_help = false;
        inline_code_actions = true;
        diagnostics_max_severity = null;
        diagnostics.inline.enabled = true;
        hover_popover_enabled = true;

        # keymap
        vim_mode = true;
        helix_mode = false;
        vim = {
          use_system_clipboard = "never";
          use_smartcase_find = use_smartcase_search;
          cursor_shape = {
            normal = cursor_shape;
            insert = "bar";
            replace = "underline";
            visual = cursor_shape;
          };
        };

        # misc
        use_system_path_prompts = false;
        use_system_prompts = false;
      };

      userKeymaps =
        let
          common = {
            # clipboard
            "space y" = "editor::Copy";
            "space p" = "editor::Paste";

            # pickers
            "space f c" = "command_palette::Toggle";
            "space f f" = "file_finder::Toggle";
            "space f b" = "tab_switcher::ToggleAll";
            "space f s" = "project_symbols::Toggle";
            "space f e" = "project_panel::ToggleFocus";
            "space f /" = "pane::DeploySearch";

            # window
            "space w h" = "workspace::ActivatePaneLeft";
            "space w l" = "workspace::ActivatePaneRight";
            "space w k" = "workspace::ActivatePaneUp";
            "space w j" = "workspace::ActivatePaneDown";
            "space w q" = "pane::CloseActiveItem";
            "space w s" = "pane::SplitRight";
            "space w r" = "pane::SplitRight";
            "space w v" = "pane::SplitDown";
            "space w d" = "pane::SplitDown";

            # code
            "space c c" = "editor::ToggleComments";
            "space c d" = "editor::GoToDiagnostic";
            "space c r" = "editor::Rename";
            "space c a" = "editor::ToggleCodeActions";

            # misc
            "space k" = "editor::Hover";
            "space h" = "editor::SelectAllMatches";
          };
        in
        [
          {
            context = "Workspace";
            bindings = {
              "ctrl-e" = "workspace::ToggleLeftDock";
            };
          }
          {
            context = "vim_mode == normal";
            bindings = { } // common;
          }
          {
            context = "vim_mode == visual";
            bindings = { } // common;
          }
        ];
    };

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
