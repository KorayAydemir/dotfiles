return {
	"stevearc/conform.nvim",
	cmd = {
		"ConformInfo",
	},
	keys = {
		{
			"<leader>fr",
			function() require("conform").format({ async = true }) end,
			mode = { "v", "n" },
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			json = { "prettierd" },
            rust = { "rustfmt" },
            toml = { "taplo" },
            go = { "gofmt" },
            -- run on filetypes that don't have any formatters configured
            ["_"] = { "prettierd" }
		},
		formatters = {
			prettierd = {
				prepend_args = { "--tab-width=4", "--print-width=100", "--config-precedence=prefer-file" },
			},
		},
	},
}
