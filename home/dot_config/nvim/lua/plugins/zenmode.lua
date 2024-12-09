local function toggle_zen_mode()
	require("zen-mode").toggle({
		window = {
			backdrop = 0.95,
			-- height and width can be:
			-- * an absolute number of cells when > 1
			-- * a percentage of the width / height of the editor when <= 1
			-- * a function that returns the width or the height
			width = 140,
			height = 1,
		},
		plugins = {
			options = {
				enabled = true,
				ruler = false, -- disables the ruler text in the cmd line area
				showcmd = false, -- disables the command in the last line of the screen
			},
			twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
			gitsigns = { enabled = false }, -- disables git signs
			-- this will change the font size on alacritty when in zen mode
			-- requires  Alacritty Version 0.10.0 or higher
			-- uses `alacritty msg` subcommand to change font size
		},
		-- callback where you can add custom code when the Zen window opens
		on_open = function(win) end,
		-- callback where you can add custom code when the Zen window closes
		on_close = function() end,
	})
end

return {
	"folke/zen-mode.nvim",
	keys = { {
		"<leader>zz",
		toggle_zen_mode,
	} },
}
