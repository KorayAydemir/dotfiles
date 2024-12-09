local function config()
	local lsp_lines = require("lsp_lines")
	lsp_lines.setup()
	vim.keymap.set("n", "<leader>l", lsp_lines.toggle)

	vim.diagnostic.config({ virtual_text = false })
end

return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	config = config,
	event = "BufReadPre",
	keys = {
		("<Leader>l"),
	},
}
