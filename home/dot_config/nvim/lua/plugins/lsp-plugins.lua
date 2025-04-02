local function nvim_lspconfig()
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
		"csharp_ls",
        "quick_lint_js"
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

    -- enable as needed
    -- lspconfig.htmx.setup({
    --     capabilities = capabilities,
    --     filetypes = 'html'
    -- })

	lspconfig.rust_analyzer.setup({
        -- TODO: where is `capabilities = capabilities` ? if its not needed, document why
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

	require("sonarlint").setup({
		server = {
			cmd = {
                "C:/Users/Koray/AppData/Local/nvim-data/mason/bin/sonarlint-language-server.cmd",
				"-stdio",
				"-analyzers",
                "C:/Users/Koray/AppData/Local/nvim-data/mason/share/sonarlint-analyzers/sonarcfamily.jar",
                "C:/Users/Koray/AppData/Local/nvim-data/mason/share/sonarlint-analyzers/sonarjs.jar"
			},
		},
		filetypes = {
			"javascript",
			"scss",
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
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		config = nvim_lspconfig,
		dependencies = { "lewis6991/gitsigns.nvim", "https://gitlab.com/schrieveslaach/sonarlint.nvim" },
	},
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
