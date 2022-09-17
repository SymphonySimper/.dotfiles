local autosave = require("auto-save")

autosave.setup({
	enabled = true,
	execution_message = {
		cleaning_interval = 1000,
	},
	trigger_events = { "InsertLeave", "TextChanged" },
	write_all_buffers = true,
	debounce_delay = 135,
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1
			and utils.not_in(fn.getbufvar(buf, "&filetype"), {})
			and utils.not_in(fn.expand("%:t"), {
				"packer.lua",
			})
		then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
})
