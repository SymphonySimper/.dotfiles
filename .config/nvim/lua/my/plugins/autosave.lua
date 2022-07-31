local autosave = require("auto-save")

autosave.setup({
	enabled = true,
	execution_message = {
		cleaning_interval = 1000,
	},
	trigger_events = { "InsertLeave", "TextChanged" },
	write_all_buffers = true,
	debounce_delay = 135,
})
