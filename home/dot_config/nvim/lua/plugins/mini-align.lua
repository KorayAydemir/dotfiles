return {
	"echasnovski/mini.align",
	version = "*",
	config = true,
	opts = {
		mappings = {
			start = "<leader>x",
			start_with_preview = "<leader>X",
		},
	},
	keys = {
		{ "<leader>x", mode = { "v" } },
		{ "<leader>X", mode = { "v" } },
	},
}
