{ ... }:
{
  programs.nixvim = {
    userCommands = {
      # show :messages in a scratch buffer
      "MyMessages" = {
        command = {
          __raw = ''
            function ()
              local window = vim.api.nvim_get_current_win()
              local buffer = vim.api.nvim_create_buf(true, true)
              vim.api.nvim_open_win(buffer, true, {
                split = "right",
                win = window
              })
              local messages = vim.split( vim.fn.execute("messages"), "\n" )
              vim.api.nvim_buf_set_lines(buffer, 0, -1, false, messages)
            end
          '';
        };
      };
      # open a sratch window
      "MySratch" = {
        command = {
          __raw = ''
            function ()
              local window = vim.api.nvim_get_current_win()
              local current_buffer = vim.api.nvim_get_current_buf()
              local buffer = vim.api.nvim_create_buf(true, true)
              vim.api.nvim_open_win(buffer, true, {
                split = "right",
                win = window
              })

              if vim.api.nvim_buf_get_name(current_buffer) == "" then
                vim.api.nvim_buf_delete(current_buffer, {})
              end
            end
          '';
        };
      };
    };

    keymaps = [
      {
        action = "<CMD>MySratch<CR>";
        key = "<leader>fs";
        mode = "n";
        options.desc = "Open a sratch in vsplit";
      }
    ];
  };
}
