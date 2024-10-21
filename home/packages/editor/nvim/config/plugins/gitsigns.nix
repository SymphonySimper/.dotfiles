{ ... }:
{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      settings = {
        current_line_blame = false;
        on_attach = # lua
          ''
            function(buffer)
              local gs = require('gitsigns')

              local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
              end

              -- stylua: ignore start
              map("n", "]h", function()
                if vim.wo.diff then
                  vim.cmd.normal({ "]c", bang = true })
                else
                  gs.nav_hunk("next")
                end
              end, "Next Hunk")
              map("n", "[h", function()
                if vim.wo.diff then
                  vim.cmd.normal({ "[c", bang = true })
                else
                  gs.nav_hunk("prev")
                end
              end, "Prev Hunk")
              map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
              map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
              map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
              map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
              map("n", "<leader>gd", gs.diffthis, "Diff This")
              map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
            end,
          '';
      };
    };
  };
}
