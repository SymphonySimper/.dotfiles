{ config, ... }:
let
  mkRaw = config.lib.nixvim.mkRaw;
in
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      luaConfig.pre = # lua
        ''
          local my_mini_hipatterns = require("mini.hipatterns")
        '';
      modules = {
        icons = { };

        hipatterns.highlighters = {
          # Highlight hex color strings (`#rrggbb`) using that color
          hex_color = mkRaw ''my_mini_hipatterns.gen_highlighter.hex_color()'';
        };

        surround.mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };

        pairs = { };

        move = { };

        bracketed = { };

        indentscope = {
          symbol = "│";
          options.try_as_border = true;
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
          windows.preview = false;
        };
      };

      luaConfig.post = # lua
        ''
          -- Open file in a split
          local map_split = function(buf_id, lhs, direction)
            local rhs = function()
              -- Make new window and set it as target
              local cur_target = MiniFiles.get_explorer_state().target_window
              local new_target = vim.api.nvim_win_call(cur_target, function()
                vim.cmd(direction .. ' split')
                return vim.api.nvim_get_current_win()
              end)

              MiniFiles.set_target_window(new_target)
              MiniFiles.go_in({ close_on_file = true })
            end

            -- Adding `desc` will result into `show_help` entries
            local desc = 'Split ' .. direction
            vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
          end

          vim.api.nvim_create_autocmd('User', {
            pattern = 'MiniFilesBufferCreate',
            callback = function(args)
              local buf_id = args.data.buf_id
              -- Tweak keys to your liking
              map_split(buf_id, '<C-s>', 'belowright horizontal')
              map_split(buf_id, '<C-v>', 'belowright vertical')
            end,
          })
        '';
    };

    keymaps = [
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
