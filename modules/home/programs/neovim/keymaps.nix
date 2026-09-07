{ ... }: {
  programs.neovim.initLua = ''
    vim.g.mapleader = " "
    vim.g.maplocalleader = " " 

    vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
    vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
    vim.keymap.set({ "n", "v" }, '<space>r', '"+_dP', { desc = 'Replace selection with system clipboard' })

    vim.keymap.set({ "n", "v" }, "<leader>bw", ":write<CR>", { silent = true, desc = "Save file" })
    vim.keymap.set({ "n", "v" }, "<leader>bd", ":bdelete<CR>", { silent = true, desc = "Close the current buffer" })
    vim.keymap.set({ "n", "v" }, "<leader>bD", ":bdelete!<CR>", { silent = true, desc = "Force close the current buffer" })

    vim.keymap.set({ "n", "v" }, "<leader>wq", ":quit<CR>", { silent = true, desc = "Quit" })

    vim.keymap.set({ "n", "v" }, "<leader>k", "<C-w>k", { silent = true, desc = "Move to top window" })
    vim.keymap.set({ "n", "v" }, "<leader>l", "<C-w>l", { silent = true, desc = "Move to right window" })
    vim.keymap.set({ "n", "v" }, "<leader>j", "<C-w>j", { silent = true, desc = "Move to bottom window" })
    vim.keymap.set({ "n", "v" }, "<leader>h", "<C-w>h", { silent = true, desc = "Move to left window" })

    vim.keymap.set({ "n", "v" }, "<leader>H", "<C-w>H", { remap = true, silent = true, desc = "Move pane far left" })
    vim.keymap.set({ "n", "v" }, "<leader>J", "<C-w>J", { remap = true, silent = true, desc = "Move pane far bottom" })
    vim.keymap.set({ "n", "v" }, "<leader>K", "<C-w>K", { remap = true, silent = true, desc = "Move pane far top" })
    vim.keymap.set({ "n", "v" }, "<leader>L", "<C-w>L", { remap = true, silent = true, desc = "Move pane far right" })

    vim.keymap.set({ "n", "v" }, "<leader>wrk", ":resize +2<CR>", { silent = true, desc = "Resize top" })
    vim.keymap.set({ "n", "v" }, "<leader>wrl", ":vertical resize +2<CR>", { silent = true, desc = "Resize right" })
    vim.keymap.set({ "n", "v" }, "<leader>wrj", ":resize -2<CR>", { silent = true, desc = "Resize bottom" })
    vim.keymap.set({ "n", "v" }, "<leader>wrh", ":vertical resize -2<CR>", { silent = true, desc = "Resize left" })
  '';
}
