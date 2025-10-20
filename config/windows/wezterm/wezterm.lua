local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Latte'

-- config.font_size = 16
config.font = wezterm.font 'JetBrainsMono Nerd Font'

config.enable_tab_bar = false
-- config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.9,
}

config.enable_scroll_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_content_alignment = {
  horizontal = 'Center',
  vertical = 'Center'
}

-- Keybinds
config.disable_default_key_bindings = true
config.keys = {}
config.key_tables = {}

local map = function(key, mods, action)
  table.insert(config.keys, { key = key, mods = mods, action = action })
end

local map_table = function(mode, key, mods, action)
  if config.key_tables[mode] == nil then
    config.key_tables[mode] = {}
  end

  table.insert(config.key_tables[mode], { key = key, mods = mods, action = action })
end

-- -- misc
map('p', 'ALT|SHIFT', act.ActivateCommandPalette)

-- -- copy mode
map('v', 'ALT', act.QuickSelect)
map('v', 'ALT|SHIFT', act.ActivateCopyMode)

-- -- clipboard
map('v', 'CTRL|SHIFT', act.PasteFrom 'Clipboard')
map('c', 'CTRL|SHIFT', act.CopyTo 'Clipboard')

-- -- Window Mode
map('w', 'ALT', act.ActivateKeyTable { name = 'window_mode', timeout_milliseconds = 1000, })

-- -- -- focus
map_table('window_mode', 'LeftArrow', nil, act.ActivatePaneDirection 'Left')
map_table('window_mode', 'h', nil, act.ActivatePaneDirection 'Left')
map_table('window_mode', 'RightArrow', nil, act.ActivatePaneDirection 'Right')
map_table('window_mode', 'l', nil, act.ActivatePaneDirection 'Right')
map_table('window_mode', 'UpArrow', nil, act.ActivatePaneDirection 'Up')
map_table('window_mode', 'k', nil, act.ActivatePaneDirection 'Up')
map_table('window_mode', 'DownArrow', nil, act.ActivatePaneDirection 'Down')
map_table('window_mode', 'j', nil, act.ActivatePaneDirection 'Down')

-- -- -- pane
map_table('window_mode', '_', 'SHIFT', act.SplitVertical { domain = 'CurrentPaneDomain' })
map_table('window_mode', '|', 'SHIFT', act.SplitHorizontal { domain = 'CurrentPaneDomain' })
map_table('window_mode', 'z', nil, act.TogglePaneZoomState)
map_table('window_mode', 'w', nil, act.PaneSelect)
map_table('window_mode', 'c', nil, act.CloseCurrentPane { confirm = true })

-- -- -- tab
map_table('window_mode', 'n', nil, act.SpawnTab 'CurrentPaneDomain')
map_table('window_mode', 't', nil, act.ShowTabNavigator)
for index = 0, 9 do
  local key = index + 1
  if key == 10 then
    key = 0
  end

  map_table('window_mode', tostring(key), nil, act.ActivateTab(index))
end

-- -- resize mode
map('r', 'ALT', act.ActivateKeyTable { name = 'resize_pane_mode', one_shot = false, })
map_table('resize_pane_mode', 'LeftArrow', nil, act.AdjustPaneSize { 'Left', 1 })
map_table('resize_pane_mode', 'h', nil, act.AdjustPaneSize { 'Left', 1 })
map_table('resize_pane_mode', 'RightArrow', nil, act.AdjustPaneSize { 'Right', 1 })
map_table('resize_pane_mode', 'l', nil, act.AdjustPaneSize { 'Right', 1 })
map_table('resize_pane_mode', 'UpArrow', nil, act.AdjustPaneSize { 'Up', 1 })
map_table('resize_pane_mode', 'k', nil, act.AdjustPaneSize { 'Up', 1 })
map_table('resize_pane_mode', 'DownArrow', nil, act.AdjustPaneSize { 'Down', 1 })
map_table('resize_pane_mode', 'j', nil, act.AdjustPaneSize { 'Down', 1 })
map_table('resize_pane_mode', 'Escape', nil, 'PopKeyTable')

-- OS specific overrides
if string.find(wezterm.target_triple, "linux") then
  config.window_decorations = "NONE"
elseif string.find(wezterm.target_triple, "windows") then
  config.default_prog = { "pwsh", "-l" }
  config.window_decorations = "RESIZE"

  -- -- maximize on startup
  wezterm.on("gui-startup", function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)
end

return config
