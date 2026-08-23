{ config, lib }:
rec {
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
}
