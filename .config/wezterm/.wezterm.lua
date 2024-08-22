local wezterm = require("wezterm")
local act = wezterm.action

return {
	window_padding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	},

	-- Fonts
	-- font = wezterm.font("IBM Plex Mono"),
	font_size = 18.0,

	-- Colors
	color_scheme = "nord", -- full list @ wezfurlong.org/wezterm/colorschemes/index.html
	colors = { -- color_scheme takes precedence over these
		foreground = "silver", -- [silver] The default text color
		background = "black", -- [black]  The default background color
		cursor_bg = "#52ad70", -- [#52ad70] Overrides the cell background color when the current cell is occupied by the cursor and the cursor style is set to Block
		cursor_fg = "black", -- [black]   Overrides the text color when the current cell is occupied by the cursor
		cursor_border = "#52ad70", -- [#52ad70] Specifies the border color of the cursor when the cursor style is set to Block, of the color of the vertical or horizontal bar when the cursor style is set to Bar or Underline.
		selection_fg = "black", -- [black]   The foreground color of selected text
		selection_bg = "#fffacd", -- [#fffacd] The background color of selected text
		scrollbar_thumb = "#222222", -- [#222222] The color of the scrollbar "thumb"; the portion that represents the current viewport
		split = "#444444", -- [#444444] The color of the split lines between panes
		-- ansi        	= {"black", "maroon", "green", "olive", "navy", "purple", "teal", "silver"},
		-- brights     	= {"grey", "red", "lime", "yellow", "blue", "fuchsia", "aqua", "white"},
		-- indexed     	= {[136]="#af8700"} , -- Arbitrary colors of the palette in the range from 16 to 255
	},

	-- Appearance
	window_background_opacity = 0.9, -- [1.0] alpha channel value with floating point numbers in the range 0.0 (meaning completely translucent/transparent) through to 1.0 (meaning completely opaque)
	enable_tab_bar = true, -- [true]
	hide_tab_bar_if_only_one_tab = true, -- [false] hide the tab bar when there is only a single tab in the window

	disable_default_key_bindings = true,
	-- leader = { key = "n", mods = "SUPER", timeout_milliseconds = 2000 },
	keys = {
		{ key = "c", mods = "CMD", action = act({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CMD", action = act({ PasteFrom = "Clipboard" }) },
		{ key = "1", mods = "CMD|SHIFT", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "CMD|SHIFT", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "CMD|SHIFT", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "CMD|SHIFT", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "CMD|SHIFT", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "CMD|SHIFT", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "CMD|SHIFT", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "CMD|SHIFT", action = act({ ActivateTab = 7 }) },

		{ key = "l", mods = "CMD|SHIFT", action = act({ MoveTabRelative = 1 }) },
		{ key = "h", mods = "CMD|SHIFT", action = act({ MoveTabRelative = -1 }) },

		{ key = "w", mods = "CMD", action = act({ CloseCurrentTab = { confirm = true } }) },
		{ key = "t", mods = "CMD", action = act({ SpawnTab = "DefaultDomain" }) },

		{ key = "b", mods = "CTRL", action = act({ ClearScrollback = "ScrollbackAndViewport" }) },
		{ key = "b", mods = "CTRL|SHIFT", action = act({ ClearScrollback = "ScrollbackOnly" }) },

		{ key = "Tab", mods = "CTRL", action = act({ ActivateTabRelative = 1 }) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = act({ ActivateTabRelative = -1 }) },

		{ key = "m", mods = "CMD|SHIFT", action = act("ActivateCopyMode") },
		{ key = "/", mods = "CMD", action = act({ Search = { CaseSensitiveString = "" } }) },
		-- { key = "v", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	},
}
