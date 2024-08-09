{ userSettings, ... }:
let
  padding = "2";
in
{
  programs.wezterm = {
    enable = userSettings.programs.terminal == "wezterm";
    extraConfig = # lua
      ''
        function capitalize(str)
            return (str:gsub("^%l", string.upper))
        end

        local wezterm = require("wezterm")
        local mux = wezterm.mux
        local config = wezterm.config_builder()
        local act = wezterm.action

        config.color_scheme = string.format("Catppuccin %s", capitalize("${userSettings.theme.flavor}"))
        config.font = wezterm.font("${userSettings.font.mono}")

        config.enable_tab_bar = false
        config.enable_scroll_bar = false
        config.window_decorations = "NONE"
        config.window_padding = {
        	left = ${padding},
        	right = ${padding},
        	top = ${padding},
        	bottom = ${padding},
        }

        config.disable_default_key_bindings = true
        config.keys = {
          {
            mods = "SHIFT|CTRL",
            key = "c",
            action = act.CopyTo "Clipboard"
          },
          {
            mods = "SHIFT|CTRL",
            key = "v",
            action = act.PasteFrom "Clipboard"
          }
        }

        if package.config:sub(1, 1) == "\\" then
          config.default_prog = { "wsl", "-d", "NixOS", "--cd", "~" }
        end

        -- wezterm.on("gui-startup", function(cmd)
        -- 	local _, _, window = mux.spawn_window(cmd or {})
        -- 	window:gui_window():maximize()
        -- end)

        return config
      '';
  };
}
