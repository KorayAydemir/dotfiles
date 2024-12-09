local function lsp_config()
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	local default_setups = {
		"ts_ls",
		"tailwindcss",
		"emmet_language_server",
		"gopls",
		"pyright",
		"pylsp",
		"clangd",
		"htmx",
		"csharp_ls",
	}

	for _, server in ipairs(default_setups) do
		lspconfig[server].setup({
			capabilities = capabilities,
		})
	end

	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
					globals = {
						"vim",
					},
				},
			},
		},
	})

	lspconfig.rust_analyzer.setup({
		check = { command = "clippy", allTargets = false },
		imports = {
			granularity = {
				group = "module",
			},
			prefix = "self",
		},
		cachePriming = false,
		cargo = {
			allTargets = false,
			buildScripts = {
				enable = false,
			},
		},
		procMacro = {
			enable = false,
		},
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf, remap = false }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

		vim.keymap.set("n", "<space>vfr", function() vim.lsp.buf.format({ async = true }) end, opts)

		vim.keymap.set("n", "<c-w>d", ":vs<cr>:lua vim.lsp.buf.definition()<cr>zt")
	end,
})

return {
	{ "neovim/nvim-lspconfig", event = "VeryLazy", config = lsp_config },

	{ "williamboman/mason.nvim", config = true, cmd = "Mason" },
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- rust-analyzer should be installed via rustup!
			ensure_installed = { "ts_ls", "lua_ls", "bashls", "tailwindcss" },
		},
		dependencies = { "williamboman/mason.nvim" },
	},

	{ "j-hui/fidget.nvim", event = "VeryLazy", opts = {} },
	{ "folke/lazydev.nvim", ft = "lua", opts = {} },
	{ "mfussenegger/nvim-jdtls", lazy = true },
}
