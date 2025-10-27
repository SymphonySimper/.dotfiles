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
      [ "my" "programs" "editor" "gui" "extensions" ]
      [ "programs" "zed-editor" "extensions" ]
    )
  ];

  options.my.programs.editor = (lib.my.mkCommandOption "Editor" "hx") // {
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

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = "Packages to add to extraPackages";
      default = [ ];
    };

    gui = {
      language = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = "GUI Editor language settings";
        default = { };
      };

      lsp = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = "GUI Editor lsp settings";
        default = { };
      };

      tasks = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              label = lib.mkOption {
                type = lib.types.str;
                description = "Label for the task";
              };

              command = lib.mkOption {
                type = lib.types.str;
                description = "Command to run";
              };

              args = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "Args for the command";
                default = [ ];
              };

              env = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                description = "Env variables for task";
                default = { };
              };

              use_new_terminal = lib.mkOption {
                type = lib.types.bool;
                description = "Spawn new terminal";
                default = false;
              };

              allow_concurrent_runs = lib.mkOption {
                type = lib.types.bool;
                description = "Allow multipe instances of the same task";
                default = false;
              };

              reveal = lib.mkOption {
                type = lib.types.enum [
                  "always"
                  "no_focus"
                  "never"
                ];
                description = "Show spawned task";
                default = "always";
              };

              reveal_target = lib.mkOption {
                type = lib.types.enum [
                  "dock"
                  "center"
                ];
                description = "Where to show spawned task";
                default = "dock";
              };

              hide = lib.mkOption {
                type = lib.types.enum [
                  "never"
                  "always"
                  "on_success"
                ];
                description = "After spawned task ends";
                default = "never";
              };

              keymap = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "Keymap for the task";
                default = null;
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkMerge [
    {
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

        copy.of = [
          {
            from = "CONFIG/helix/";
            to = "WINDOWS/helix/";
            exclude = [ "runtime/" ];

            post = # sh
              ''
                sed -i '4i shell = ["pwsh", "-Command"] ' "WINDOWS/helix/config.toml"
              '';
          }
        ];
      };

      xdg.configFile."helix/ignore".text = builtins.concatStringsSep "\n" (lib.lists.unique cfg.ignore);

      programs.helix = {
        enable = true;
        package = inputs.helix.packages.${my.system}.default;
        defaultEditor = true;
        extraPackages = cfg.packages;

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

            statusline = {
              left = [
                "mode"
                "file-name"
              ];

              right = [
                "spinner"
                "diagnostics"
                # "version-control"
                "selections"
                # "register"
                # "position"
                "read-only-indicator"
                "file-modification-indicator"
              ];
            };
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

                # external programs
                e =
                  let
                    cfgT = config.my.programs.terminal;
                  in
                  {
                    y = ":sh ${cfgT.command} ${cfgT.args.command} ${config.my.programs.file-manager.command} $(realpath %{buffer_name})";
                    g = ":sh ${cfgT.command} ${cfgT.args.command} ${config.my.programs.vcs.tui.command} ${config.my.programs.vcs.tui.args.path} %{workspace_directory}";
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

                # vcs
                g =
                  let
                    vcs = config.my.programs.vcs.command;
                  in
                  {
                    b = ":sh ${vcs} -C %{workspace_directory} blame -L %{cursor_line},%{cursor_line} $(realpath %{buffer_name})";

                    B = ":echo %sh{${vcs} branch --show-current}";
                    R = ":reset-diff-change";
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
    }

    (lib.mkIf my.gui.enable {
      home.activation = {
        myRmZedConfig =
          let
            configDir = "${config.xdg.configHome}/zed/";
          in
          lib.hm.dag.entryBefore [ "zedSettingsActivation" ] # sh
            ''
              if [ -d "${configDir}" ]; then
                rm -rf "${configDir}"
              fi
            '';
      };

      my.programs = {
        editor.gui.tasks = {
          vcsTUI = {
            label = "Start VCS TUI";
            command = config.my.programs.vcs.tui.command;
            args = [
              "-p"
              "$ZED_WORKTREE_ROOT"
            ];
            reveal_target = "center";
            hide = "always";
            keymap = "g";
            use_new_terminal = true;
          };

          fileManagerTUI = {
            label = "Start TUI File-Manager";
            command = config.my.programs.file-manager.command;
            args = [ "$ZED_DIRNAME" ];
            reveal_target = "center";
            hide = "always";
            keymap = "y";
            use_new_terminal = true;
          };
        };

        copy.of = [
          {
            from = "CONFIG/zed/";
            to = "WINDOWS/zed/";
          }
        ];
      };

      catppuccin.zed.enable = false;

      programs.zed-editor = {
        enable = true;
        extraPackages = cfg.packages;

        extensions = [
          "catppuccin"
          # "catppuccin-icons" # slows down startup
        ];

        userSettings = rec {
          disable_ai = true;
          base_keymap = "VSCode";

          # font
          buffer_font_family = my.theme.font.mono;
          ui_font_size = 16;
          buffer_font_size = 15;

          theme = {
            mode = "system";
            light = "Catppuccin ${lib.strings.toSentenceCase my.theme.flavors.light}";
            dark = "Catppuccin ${lib.strings.toSentenceCase my.theme.flavors.dark}";
          };
          # icon_theme = theme; # slows down startup

          minimap.show = "never";

          title_bar = {
            show_branch_icon = true;
            show_branch_name = true;
            show_sign_in = false;
          };

          toolbar = {
            agent_review = false;
            code_actions = false;
            breadcrumbs = false;
            quick_actions = false;
            selections_menu = false;
          };

          tab_bar.show = true;
          tabs = {
            show_close_button = "hover";
            show_diagnostics = "all";
            file_icons = true;
            git_status = true;
          };

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

          # restore
          restore_on_startup = "last_session";
          restore_on_file_reopen = false;
          session.restore_unsaved_buffers = false;

          # misc
          use_system_path_prompts = false;
          use_system_prompts = false;

          languages = cfg.gui.language;
          lsp = cfg.gui.lsp;
        };

        userTasks = builtins.map (task: lib.attrsets.removeAttrs task [ "keymap" ]) (
          builtins.attrValues cfg.gui.tasks
        );

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
              "space f o" = "workspace::Open";
              # window
              "space w c" = "pane::CloseCleanItems";
              "space w shift-c" = "pane::CloseAllItems";

              # code
              "space c c" = "editor::ToggleComments";
              "space c d" = "editor::GoToDiagnostic";
              "space c r" = "editor::Rename";
              "space c a" = "editor::ToggleCodeActions";
              "space c f" = "editor::Format";

              # buffer (active pane)
              "space b w" = "workspace::Save";
              "space b f" = common."space f b";
              "space b c" = "pane::CloseActiveItem";

              # git
              "space g g" = "git_panel::ToggleFocus";
              "space g a" = "git::ToggleStaged";
              "space g u" = "git::StageAndNext";
              "space g shift-u" = "git::UnstageAndNext";
              "space g b" = "editor::BlameHover";
              "space g r" = "git::Restore";
              "space g c" = "git::Commit";
              "space g shift-a" = "git::Amend";
              "space g p" = "git::Pull";
              "space g shift-p" = "git::Push";
              "space g d" = "git::Diff";
              "space g shift-b" = "git::Branch";

              # surround
              "m s" = "vim::PushAddSurrounds";
              "m r" = "vim::PushChangeSurrounds";
              "m d" = "vim::PushDeleteSurrounds";
              "m m" = "vim::Matching";
              "m i" = [
                "vim::PushObject"
                { "around" = false; }
              ];
              "m a" = [
                "vim::PushObject"
                { "around" = true; }
              ];

              # misc
              "space k" = "editor::Hover";
              "space h" = "editor::SelectAllMatches";
            };
          in
          [
            {
              bindings = {
                "alt-f o" = "workspace::Open";
                "alt-f b" = "tab_switcher::ToggleAll";
                "alt-f p" = "command_palette::Toggle";
                "alt-f f" = "file_finder::Toggle";
                "alt-f e" = "project_panel::ToggleFocus";
                "alt-f s" = "pane::DeploySearch";
                "alt-f t" = "task::Spawn";

                "alt-w c" = "pane::CloseActiveItem";
                "alt-w shift-c" = "pane::CloseAllItems";
                "alt-w |" = "pane::SplitRight";
                "alt-w _" = "pane::SplitDown";

                "alt-w w" = "workspace::CloseWindow";
                "alt-w z" = "workspace::ToggleZoom";
                "alt-w h" = "workspace::ActivatePaneLeft";
                "alt-w l" = "workspace::ActivatePaneRight";
                "alt-w k" = "workspace::ActivatePaneUp";
                "alt-w j" = "workspace::ActivatePaneDown";
                "alt-w shift-h" = "workspace::SwapPaneLeft";
                "alt-w shift-l" = "workspace::SwapPaneRight";
                "alt-w shift-k" = "workspace::SwapPaneUp";
                "alt-w shift-j" = "workspace::SwapPaneDown";

                "alt-d t" = "terminal_panel::Toggle";
                "alt-d h" = "workspace::ToggleLeftDock";
                "alt-d j" = "workspace::ToggleBottomDock";
                "alt-d k" = "workspace::CloseAllDocks";
                "alt-d l" = "workspace::ToggleRightDock";

                "alt-g g" = "git_panel::ToggleFocus";
                "alt-g c" = "git::Commit";
                "alt-g shift-a" = "git::Amend";
                "alt-g p" = "git::Pull";
                "alt-g shift-p" = "git::Push";
                "alt-g d" = "git::Diff";
                "alt-g b" = "git::Branch";
                "alt-g shift-b" = "git::Blame";

                "alt-shift-q" = "zed::Quit";
              }
              // (builtins.listToAttrs (
                builtins.map (task: {
                  name = "alt-t ${task.keymap}";
                  value = [
                    "task::Spawn"
                    { task_name = task.label; }
                  ];
                }) (builtins.filter (task: task.keymap != null) (builtins.attrValues cfg.gui.tasks))
              ));
            }
            {
              context = "vim_mode == normal";
              bindings = {
                # multi-cursor
                "shift-c" = "editor::AddSelectionBelow";
                "alt-c" = "editor::AddSelectionAbove";
                ";" = "vim::HelixCollapseSelection";
              }
              // common;
            }
            {
              context = "vim_mode == visual";
              bindings = { } // common;
            }
          ];
      };
    })
  ];
}
