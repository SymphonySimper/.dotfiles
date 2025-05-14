{ pkgs, lib, ... }:
{
  programs.helix.settings.keys = {
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
}
