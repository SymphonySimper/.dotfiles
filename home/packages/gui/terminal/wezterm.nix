{ userSettings, ... }:
{
  programs.wezterm = {
    enable = if userSettings.programs.terminal == "wezterm" then true else false;
    extraConfig = # lua
      ''
        local wezterm = require("wezterm")
        local mux = wezterm.mux
        local config = wezterm.config_builder()

        config.color_scheme = "Catppuccin Mocha"
        config.font = wezterm.font(${userSettings.font.mono})

        config.enable_tab_bar = false
        config.enable_scroll_bar = false
        config.window_decorations = "NONE"
        config.window_padding = {
        	left = 8,
        	right = 8,
        	top = 8,
        	bottom = 8,
        }

        config.disable_default_key_bindings = true
        if package.config:sub(1, 1) == "\\" then
          config.default_prog = { "wsl", "-d", "NixOS", "--cd", "~" }
        end

        wezterm.on("gui-startup", function(cmd)
        	local _, _, window = mux.spawn_window(cmd or {})
        	window:gui_window():maximize()
        end)

        return config
      '';
  };
}
