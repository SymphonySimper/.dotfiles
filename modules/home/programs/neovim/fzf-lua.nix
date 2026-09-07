{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.fzf-lua;
      type = "lua";
      config = ''
        local fzf = require("fzf-lua")

        fzf.setup({
          ui_select = {},

          prompt = "> ",

          winopts = {
            backdrop = 0,
            fullscreen = true,
            title_pos = "left",
            preview = { title = false }
          },

          files = { cwd_prompt = false, },

          keymap = {
            builtin = {
              -- Scroll half-page down / up
              ["<C-j>"] = "preview-page-down",
              ["<C-k>"] = "preview-page-up",

              -- Scroll single lines
              ["<C-d>"] = "preview-down",
              ["<C-u>"] = "preview-up",

              -- Reset preview position back to top
              ["<C-r>"] = "preview-reset",
            }
          }
        })

        -- set border color to line number color
        vim.api.nvim_set_hl(0, "FzfLuaBorder", {
          link = "LineNr",
        })


        vim.keymap.set({ "n", "v" }, "<leader>f'", fzf.resume, { desc = "FZF Resume last picker" })

        vim.keymap.set({ "n", "v" }, "<leader>ff", fzf.files, { desc = "FZF Find Files" })
        vim.keymap.set({ "n", "v" }, "<leader>fF", function()
          local dir = vim.fn.expand("%:p:h")

          require("fzf-lua").files({
            cwd = dir ~= "" and dir or vim.loop.cwd(),
          })
        end)

        vim.keymap.set({ "n", "v" }, "<leader>f/", fzf.live_grep, { desc = "FZF Live Grep" })
        vim.keymap.set({ "n", "v" }, "<leader>fg", fzf.git_status, { desc = "FZF Git Status" })
        vim.keymap.set({ "n", "v" }, "<leader>fb", fzf.buffers, { desc = "FZF Buffers" })
      '';
    }
  ];
}
