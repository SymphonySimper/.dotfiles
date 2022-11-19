local nvim_web_devicons = require("nvim-web-devicons")

local current_icons = nvim_web_devicons.get_icons()
local new_icons = {}

for key, icon in pairs(current_icons) do
	icon.color = "#ababab"
	new_icons[key] = icon
end

nvim_web_devicons.set_icon(new_icons)
