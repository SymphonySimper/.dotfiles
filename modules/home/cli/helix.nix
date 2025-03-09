{
  my,
  inputs,
  config,
  pkgs,
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

  config = {
    home.packages = [
      (pkgs.writeShellScriptBin "myhelix" # sh
        ''
          case "$1" in
            gb)
              rm -rf ~/.config/helix/runtime/grammars
              hx -g fetch
              hx -g build
            ;;
          esac
        ''
      )
    ];

    xdg.configFile."helix/ignore".text = # git-ignore
      ''
        # general
        .DS_Store
        /build
        **/*:Zone.Identifier

        ## binary
        **/*.exe
        **/*.zip
        **/*.parquet
        ### media
        **/*.png
        **/*.jp[e]?g
        **/*.web[pm]
        ### doc
        **/*.pdf
        **/*.epub
        **/*.odt
        **/*.doc[x]?
        **/*.calc
        **/*.xls[x]?

        # js
        node_modules
        vite.config.js.timestamp-*
        vite.config.ts.timestamp-*
        ## svelte
        .svelte-kit

        # py
        .venv
        venv
        **/__pycache__/

        # DO NOT IGNORE
        !.github/
        !.gitignore
        !.gitattributes
        !.env*
      '';

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
              b = ":sh ${lib.getExe pkgs.git} -C $(dirname $(realpath %{buffer_name})) blame -L %{cursor_line},%{cursor_line} $(realpath %{buffer_name})";
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
      };

      languages = {
        use-grammars.only = config.programs.helix.grammars;
        language-server = config.programs.helix.lsp;
        language = config.programs.helix.language;
      };
    };
  };
}
