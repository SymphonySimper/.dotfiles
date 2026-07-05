{ den, ... }: {
  flake-file = {
    inputs.helix.url = "github:helix-editor/helix";

    nixConfig = {
      extra-substituters = [ "https://helix.cachix.org?priority=4" ];
      extra-trusted-public-keys = [ "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=" ];
    };
  };

  den.default.includes = [ den.aspects.apps.helix ];

  den.aspects.apps.helix = {
    homeManager =
      {
        inputs',
        config,
        lib,
        ...
      }:
      let
        cfg = config.programs.helix;
      in
      {
        options.programs.helix = {
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
          home.sessionVariables = rec {
            EDITOR = lib.getExe cfg.package;
            VISUAL = EDITOR;
          };

          programs.helix = {
            enable = true;
            package = inputs'.helix.packages.default;

            ignores = [
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

              # Do not ignore
              "!.github/"
              "!.env*"
            ];

            settings = {
              editor = {
                mouse = false;
                line-number = "relative";
                auto-format = false;
                bufferline = "never";
                auto-pairs = true;
                indent-guides.render = false;
                soft-wrap.enable = true;
                buffer-picker.start-position = "current";

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
                      C = ":bc!";
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

                    f = {
                      "'" = "last_picker";
                      b = "buffer_picker";
                      d = "diagnostics_picker";
                      D = "workspace_diagnostics_picker";
                      e = "file_explorer_in_current_directory";
                      E = "file_explorer_in_current_buffer_directory";
                      f = "file_picker_in_current_directory";
                      F = "file_picker_in_current_buffer_directory";
                      g = "changed_file_picker";
                      "/" = "global_search";
                      j = "jumplist_picker";
                      s = "symbol_picker";
                      S = "workspace_symbol_picker";
                    };

                    # vcs
                    g =
                      let
                        vcs = lib.getExe config.programs.git.package;
                      in
                      {
                        b = ":sh ${vcs} -C %{workspace_directory} blame -L %{cursor_line},%{cursor_line} %{file_path_absolute}";

                        B = ":echo %sh{${vcs} branch --show-current}";
                        R = ":reset-diff-change";
                      };

                    # macros
                    m = {
                      n = "@:e <C-r>%<C-w>"; # create file relative to current file
                      x = "@i<lt>xxx<gt><ret><lt>/xxx<gt><esc>k2xsxxx<ret>c"; # create xml tag
                    };

                    q = ":quit";
                    Q = ":quit!";
                  };
                };

                select = normal;

                insert = {
                  C-p = "signature_help";
                };
              };
            };
          };
        };
      };
  };
}
