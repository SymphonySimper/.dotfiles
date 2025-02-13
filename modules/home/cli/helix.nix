{
  my,
  inputs,
  config,
  lib,
  ...
}:
{
  options.programs.helix = {
    grammars = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Treesitter grammars to install";
      default = [ ];
    };

    lsp = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Alias for languages.langauge-server";
      default = { };
    };

    language = lib.mkOption {
      type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
      description = "Alias for languages.langauge";
      default = [ ];
    };
  };

  config.programs.helix = {
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
        };
      };

      keys.normal = {
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
          };

          q = ":quit";
        };
      };
    };

    languages = {
      use-grammars.only = config.programs.helix.grammars;
      language-server = config.programs.helix.lsp;
      language = config.programs.helix.language;
    };
  };
}
