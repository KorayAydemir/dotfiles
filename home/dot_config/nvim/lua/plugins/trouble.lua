local function config()
	local trouble = require("trouble")
	vim.keymap.set("n", "<leader>tt", function() trouble.toggle("diagnostics") end)
end

return {
	"folke/trouble.nvim",
	config = config,
	keys = {
		"<leader>tt",
	},
}
