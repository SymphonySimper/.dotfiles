local autosave = require("autosave")

autosave.setup({
	enabled = true,
	execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
	events = { "InsertLeave" },
	conditions = {
		exists = true,
		filename_is_not = { "packer.lua" },
		filetype_is_not = { "vimwiki", "markdown", "groff" },
		modifiable = true,
	},
	write_all_buffers = true,
	on_off_commands = true,
	clean_command_line_interval = 1000,
	debounce_delay = 1000,
})
