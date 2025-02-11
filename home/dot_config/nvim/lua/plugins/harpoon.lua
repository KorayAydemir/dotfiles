local opts = {
	settings = { save_on_toggle = true },
}

local function config()
	local harpoon = require("harpoon")
    local harpoon_extensions = require("harpoon.extensions")

	harpoon:setup(opts)

	vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
	vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

	vim.keymap.set("n", "<leader>hw", function() harpoon:list():select(1) end)
	vim.keymap.set("n", "<leader>he", function() harpoon:list():select(2) end)
	vim.keymap.set("n", "<leader>hr", function() harpoon:list():select(3) end)
	vim.keymap.set("n", "<leader>hf", function() harpoon:list():select(4) end)

	harpoon:extend({
		UI_CREATE = function(cx)
			vim.keymap.set(
				"n",
				"<C-n>",
				function() harpoon.ui:select_menu_item({ vsplit = true }) end,
				{ buffer = cx.bufnr }
			)
		end,
	})

    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = config,
	keys = {
		"<leader>a",
		"<C-e>",
		"<leader>hw",
		"<leader>he",
		"<leader>hr",
		"<leader>hf",
	},
}
