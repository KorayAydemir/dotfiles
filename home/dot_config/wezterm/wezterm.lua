local wezterm = require("wezterm")
local act = wezterm.action

local is_mac <const> = wezterm.target_triple == "aarch64-apple-darwin"
local is_linux <const> = wezterm.target_triple == "86_64-unknown-linux-gnu"
local is_win <const> = wezterm.target_triple == "x86_64-pc-windows-msvc"
local SUPER = is_mac and "CMD" or "ALT"

local one = is_win and "!" or "1"
local two = is_win and "@" or "2"
local three = is_win and "#" or "3"
local four = is_win and "$" or "4"
local five = is_win and "%" or "5"
local six = is_win and "^" or "6"
local seven = is_win and "&" or "7"
local eight = is_win and "*" or "8"
local nine = is_win and "(" or "9"


wezterm.on("format-tab-title", function(tab)
    -- Equivalent to POSIX basename(3)
    -- Given "/foo/bar" returns "bar"
    -- Given "c:\\foo\\bar" returns "bar".
    local function basename(s)
        return string.gsub(s, '(.*[/\\])(.*)', '%2')
    end

    local pane_cwd = tab.active_pane.current_working_dir.file_path
    local pane_cwd_without_last_slash = pane_cwd:sub(1, -2)

    return basename(pane_cwd_without_last_slash)
end)

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
	local text = pane:get_lines_as_text(2000)

	-- Create a temporary file to pass to vim
	local name = os.tmpname()
	local f = io.open(name, "w+")
	if not f then
		return
	end
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running vim and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { is_mac and "/opt/homebrew/bin/nvim" or "nvim", name },
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
	{ key = nine, mods = SUPER .. "|SHIFT", action = act({ ActivateTab = 8 }) },

	{ key = "l", mods = SUPER .. "|SHIFT", action = act({ MoveTabRelative = 1 }) },
	{ key = "h", mods = SUPER .. "|SHIFT", action = act({ MoveTabRelative = -1 }) },
	{ key = "Tab", mods = "CTRL", action = act({ ActivateTabRelative = 1 }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act({ ActivateTabRelative = -1 }) },

	{ key = "w", mods = SUPER, action = act({ CloseCurrentTab = { confirm = true } }) },
	{ key = "f", mods = SUPER, action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "t", mods = SUPER, action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir }) },
}

local otherKeys = {
	{ key = "c", mods = SUPER, action = act({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = SUPER, action = act({ PasteFrom = "Clipboard" }) },

	{ key = "b", mods = "CTRL", action = act({ ClearScrollback = "ScrollbackAndViewport" }) },
	{ key = "b", mods = "CTRL|SHIFT", action = act({ ClearScrollback = "ScrollbackOnly" }) },

	{ key = "m", mods = SUPER, action = act.EmitEvent("trigger-vim-with-scrollback") },
	{ key = "/", mods = SUPER, action = act({ Search = { CaseSensitiveString = "" } }) },

	{ key = "+", mods = SUPER .. "|SHIFT", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = SUPER, action = wezterm.action.DecreaseFontSize },
}

local config = {
	default_prog = { is_win and "pwsh" or is_mac and "/opt/homebrew/bin/bash" },
	max_fps = 144,
	window_padding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	},

	font_size = is_win and 16.0 or 18.0,

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