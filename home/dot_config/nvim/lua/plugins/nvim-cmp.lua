local function config()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	local opts = {
		sources = {
            -- todo figure out why keyword_length option does not work
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "cmp-tw2css" },
            { name = "buffer" },
			{ name = "path" },
		},
		completion = {
			completeopt = "menuone,noinsert",
		},
        -- using it without this for a while to see if this is needed
        -- performance = {
        --     fetching_timeout = 1
        -- },
		mapping = cmp.mapping.preset.insert({
			["S-Tab"] = nil,
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-e>"] = cmp.mapping.abort(),
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-d>"] = cmp.mapping.scroll_docs(4),

			["<C-p>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_prev_item({ behavior = "select" })
				else
					cmp.complete()
				end
			end),
			["<C-n>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = "select" })
				else
					cmp.complete()
				end
			end),

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					fallback()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
				cmp.mapping.select_next_item()
			end, { "i", "s" }),
		}),
		snippet = {
			expand = function(args) luasnip.lsp_expand(args.body) end,
		},
		enabled = function()
			local context = require("cmp.config.context")
			if vim.api.nvim_get_mode().mode == "c" then
				return true
			else
				if vim.bo.buftype == "prompt" then return false end
				return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
			end
		end,
	}

	cmp.setup(opts)
end

return {
	{
		"hrsh7th/nvim-cmp",
		config = config,
		event = "InsertEnter",
		lazy = true,
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			{
				"jcha0713/cmp-tw2css",
				opts = {
					fallback = false,
				},
			},
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-buffer" }
		},
	},
}
