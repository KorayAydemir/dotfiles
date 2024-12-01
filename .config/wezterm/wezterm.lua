local wezterm = require("wezterm")
local act = wezterm.action

local OS = os.getenv("HOME") and "mac" or "win"
local SUPER = OS == "mac" and "CMD" or "ALT"

local one = OS == "mac" and "1" or "!"
local two = OS == "mac" and "2" or "@"
local three = OS == "mac" and "3" or "#"
local four = OS == "mac" and "4" or "$"
local five = OS == "mac" and "5" or "%"
local six = OS == "mac" and "6" or "^"
local seven = OS == "mac" and "7" or "&"
local eight = OS == "mac" and "8" or "*"

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	local text = pane:get_lines_as_text(2000)

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
    if not f then return end
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { "nvim", name },
		}),
		pane
	)

	-- Wait "enough" time for vim to read the file before we remove it.
	-- The window creation and process spawn are asynchronous wrt. running
	-- this script and are not awaitable, so we just pick a number.
	--
	-- Note: We don't strictly need to remove this file, but it is nice
	-- to avoid cluttering up the temporary directory.
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

local tabKeys = {
	{ key = one, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 0 }) },
	{ key = two, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 1 }) },
	{ key = three, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 2 }) },
	{ key = four, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 3 }) },
	{ key = five, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 4 }) },
	{ key = six, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 5 }) },
	{ key = seven, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 6 }) },
	{ key = eight, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 7 }) },

	{ key = "l", mods = SUPER .. "|SHIFT", action = act({ MoveTabRelative = 1 }) },
	{ key = "h", mods = SUPER .. "|SHIFT", action = act({ MoveTabRelative = -1 }) },
	{ key = "Tab", mods = "CTRL", action = act({ ActivateTabRelative = 1 }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act({ ActivateTabRelative = -1 }) },

	{ key = "w", mods = SUPER, action = act({ CloseCurrentTab = { confirm = true } }) },
	{ key = "f", mods = SUPER, action = act.SpawnTab'CurrentPaneDomain' },
	{ key = "t", mods = SUPER, action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },
}

local otherKeys = {
	{ key = "c", mods = SUPER, action = act({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = SUPER, action = act({ PasteFrom = "Clipboard" }) },

	{ key = "b", mods = "CTRL", action = act({ ClearScrollback = "ScrollbackAndViewport" }) },
	{ key = "b", mods = "CTRL|SHIFT", action = act({ ClearScrollback = "ScrollbackOnly" }) },

	{ key = "m", mods = SUPER, action = act.EmitEvent("trigger-vim-with-scrollback") },
    { key = "/", mods = SUPER, action = act({ Search = { CaseSensitiveString = "" } }) },

    { key = '+', mods = SUPER .. "|SHIFT", action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = SUPER, action = wezterm.action.DecreaseFontSize },
}

local config = {
	default_prog = { "pwsh" },
	max_fps = 144,
	window_padding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	},

	font_size = OS == "win" and 16.0 or 18.0,

	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,

    adjust_window_size_when_changing_font_size = false,

	disable_default_key_bindings = false,
	keys = {},
}

for _, v in ipairs(tabKeys) do
	table.insert(config.keys, v)
end
for _, v in ipairs(otherKeys) do
	table.insert(config.keys, v)
end

return config
