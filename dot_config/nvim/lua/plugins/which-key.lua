local opts = {
	preset = "modern",
}
return {
	"folke/which-key.nvim",
	opts = opts,
	event = "VeryLazy",
	keys = {
		{
            "<leader>?",
            function() require("which-key").show({ global = false }) end,
            desc = "Buffer Local Keymaps (which-key)",
        },
	},

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
}
