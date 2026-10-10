{ ... }: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {
        files = {
          windows.max_number = 3;
        };

        pairs = { };

        surround.mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
        };
      };
    };

    keymaps = [
      {
        action.__raw = ''
          function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)

            if vim.v.count == 0 and (char == '"' or char == "'" or char == '`') then
              -- Include both quotes for operators such as d%.
              local inclusive = vim.fn.mode(1):sub(1, 2) == "no" and "v" or ""
              vim.api.nvim_feedkeys(inclusive .. "gsf" .. char, "mi", false)
              return ""
            end

            return "%"
          end
        '';
        key = "%";
        mode = [
          "n"
          "x"
          "o"
        ];
        options = {
          expr = true;
          silent = true;
          desc = "Jump to matching bracket or quote";
        };
      }
      {
        action.__raw = ''
          function()
            require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
          end
        '';
        key = "<leader>fm";
        mode = "n";
        options.desc = "Open mini.files (Directory of Current File)";
      }
      {
        action.__raw = ''
          function()
            require("mini.files").open(vim.uv.cwd(), true)
          end
        '';
        key = "<leader>fM";
        mode = "n";
        options.desc = "Open mini.files (cwd)";
      }
    ];
  };
}
