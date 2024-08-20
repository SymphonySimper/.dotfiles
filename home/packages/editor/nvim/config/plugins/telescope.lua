local telescope = require("telescope")
telescope.setup({
	defaults = {
		file_ignore_patterns = {
			"^.git/",
			"^node_modules/",
			"^build/",
			"^.mypy_cache/",
			"^__pycache__/",
			"^output/",
			"^data/",
			"%.ipynb",
		},
	},
	extensions = { fzf = { case_mode = "smart_case" } },
})

local keymaps = {
	{
		"find_files",
		"root",
		"<leader>fF",
		"Telescope find_files",
	},
	{
		"find_files",
		"",
		"<leader>ff",
		"Telescope find_files",
	},
	{
		"find_files",
		"buffer",
		"<leader>fc",
		"Find files from current file",
	},

	-- Buffers
	{
		"buffers",
		"",
		"<leader><space>",
		"Telescope find buffer",
	},

	-- Live grep
	{
		"live_grep",
		"root",
		"<leader>sG",
		"Telescope find string (Root)",
	},
	{
		"live_grep",
		"",
		"<leader>sg",
		"Telescope find string",
	},
}

local builtins = require("telescope.builtin")
local function get_builtin(type, builtin)
	if type == "root" then
		local function is_git_repo()
			vim.fn.system("git rev-parse --is-inside-work-tree")

			return vim.v.shell_error == 0
		end

		local function get_git_root()
			local dot_git_path = vim.fn.finddir(".git", ".;")
			return vim.fn.fnamemodify(dot_git_path, ":h")
		end

		local opts = {}

		if is_git_repo() then
			opts = {
				cwd = get_git_root(),
			}
		end

		builtin(opts)
	elseif type == "buffer" then
		builtin({ cwd = vim.fn.expand("%:p:h") })
	else
		builtin()
	end
end

for _, keymap in pairs(keymaps) do
	vim.keymap.set({ "n", "v" }, keymap[3], function()
		get_builtin(keymap[2], builtins[keymap[1]])
	end, { desc = keymap[4] })
end
