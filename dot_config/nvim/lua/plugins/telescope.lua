local function set_keys()
	local builtin = require("telescope.builtin")

	local showHidden = {
		hidden = true,
		follow = true,
		layout_config = { height = 100 },
	}

	-- C-q puts results in quickfix list

	-- Search all files in cwd.
	vim.keymap.set("n", "<leader>pf", function() builtin.find_files(showHidden) end)

	-- Search output of `git ls-files` command. Shows only staged files, respects .gitignore
	vim.keymap.set("n", "<leader>pd", function() builtin.git_files(showHidden) end)

	-- Search anything
	vim.keymap.set("n", "<leader>pg", function() builtin.live_grep() end)

	-- Search the word under cursor
	vim.keymap.set("n", "<leader>pw", function() builtin.grep_string() end)

	-- Search search history (/) and run on enter
	vim.keymap.set("n", "<leader>hh", function() builtin.search_history() end)

	-- Search commands history and run on enter
	vim.keymap.set("n", "<leader>p;", function() builtin.command_history() end)

	-- Search plugin/user commands
	vim.keymap.set("n", "<leader>p'", function() builtin.commands() end)

	-- Search marks
	vim.keymap.set("n", "<leader>pm", function() builtin.marks() end)

	-- Search jumplist
	vim.keymap.set("n", "<leader>jl", function() builtin.jumplist() end)

	-- Search vim options and set on enter
	vim.keymap.set("n", "<leader>po", function() builtin.vim_options() end)

	-- Search vim registers and paste on enter

	vim.keymap.set("n", "<leader>po", function() builtin.registers() end)

	-- Live fuzzy search inside the current buffer
	vim.keymap.set("n", "<leader>/", function() builtin.current_buffer_fuzzy_find() end)

	-- List results of the previous picker
	vim.keymap.set("n", "<C-p>", function() builtin.resume() end)

	-- List previous pickers and run on enter
	vim.keymap.set("n", "<leader>pi", function() builtin.pickers() end)

	-- List incoming calls to word under cursor
	vim.keymap.set("n", "<leader>ic", function() builtin.lsp_incoming_calls() end)

	-- List git status with diff preview
	vim.keymap.set("n", "<leader>gs", function() builtin.git_status() end)

	vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

	vim.keymap.set("n", "<leader>vrr", builtin.lsp_references, {})

	---- Search input in current working directory, respects .gitignore
	vim.keymap.set("n", "<leader>gr", function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)

	-- Search word under cursor
	vim.keymap.set("n", "<leader>gw", function() builtin.grep_string({ search = vim.fn.expand("<cword>") }) end)
end

local config = function()
	local layout = require("telescope.actions.layout")

	local opts = {
		defaults = {
			path_display = { filename_first = { reverse_directories = true } },
			preview = {
				filesize_limit = 0.15, -- MB
				highlight_limit = 0.15, -- MB
			},
			layout_config = {
				width = 300,
				height = 100,
				preview_cutoff = 90,
			},
			cache_picker = {
				num_pickers = 4,
			},
			file_ignore_patterns = {
				".git",
			},
			mappings = {
				i = {
					["<C-a>"] = layout.toggle_preview,
				},
				n = {
					["<C-a>"] = layout.toggle_preview,
				},
			},
		},
		pickers = {},
	}

	local telescope = require("telescope")
	telescope.load_extension("fzf")
	telescope.load_extension("undo")

	set_keys()

	require("telescope").setup(opts)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		config = config,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"debugloop/telescope-undo.nvim",
		},
		keys = {
			{ "<leader>pf", desc = "Find files in cwd" },
			"<leader>pd",
			"<leader>pg",
			"<leader>pw",
			"<leader>hh",
			"<leader>p;",
			"<leader>p'",
			"<leader>pm",
			"<leader>jl",
			"<leader>po",
			"<leader>po",
			"<leader>/",
			"<leader>pe",
			"<leader>pi",
			"<leader>ic",
			"<leader>gs",
			"<leader>u",
			"<leader>vrr",
			"<leader>gr",
			"<C-p>",
		},
	},
}
