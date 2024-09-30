{ lib, ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = { };

        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };

        pairs = { };

        move = { };

        bracketed = { };

        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
          };
        };

        files = {
          mappings = {
            close = "q";
            go_in = "";
            go_in_plus = "<CR>";
            go_out = "-";
            go_out_plus = "_";
            mark_goto = "'";
            mark_set = "m";
            reset = "<BS>";
            reveal_cwd = "@";
            show_help = "g?";
            synchronize = "=";
            trim_left = "<";
            trim_right = ">";
          };
          options = {
            permanent_delete = false;
            use_as_default_explorer = true;
          };
          windows.preview = true;
        };
      };
    };

    keymaps = (
      lib.my.mkKeymaps [
        [
          {
            __raw = ''
              function()
              	require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
              end
            '';
          }
          "<leader>fm"
          "n"
          "Open mini.files (Directory of Current File)"
        ]
        [
          {
            __raw = ''
              function()
              	require("mini.files").open(vim.uv.cwd(), true)
              end
            '';
          }
          "<leader>fM"
          "n"
          "Open mini.files (cwd)"
        ]
      ]
    );
  };
}
