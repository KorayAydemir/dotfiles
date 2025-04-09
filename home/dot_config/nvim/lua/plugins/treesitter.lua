local opts = {
	ensure_installed = { "javascript", "css", "typescript", "html", "lua", "regex", "rust", "c", "tsx", "vimdoc" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	ignore_install = {},

	modules = {},

	autotag = {
		enable = true,
	},

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			compilers = { "clang", "gcc" },
		},

		config = function() require("nvim-treesitter.configs").setup(opts) end,
		event = "VeryLazy",
		dependencies = {
			{ "windwp/nvim-ts-autotag" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					enable = true,
					max_lines = 5,
					min_window_height = 0,
					line_numbers = true,
					multiline_threshold = 1,
					trim_scope = "outer",
					mode = "cursor",
					separator = "",
					zindex = 20,
				},
			},
		},
	},
}
