local harpoon = require("harpoon")

harpoon:setup({
	settings = {
		save_on_toggle = true,
	},
})

vim.keymap.set("n", "<leader>H", function()
	harpoon:list():add()
end, { desc = "Harpoon file" })
vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })

for i = 1, 5 do
	vim.keymap.set("n", "<leader>" .. i, function()
		harpoon:list():select(i)
	end, { desc = "Harpoon to File " .. i })
end
