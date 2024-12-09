local opts = {
    enabled = false;
}

return {
	"f-person/git-blame.nvim",
    opts = opts,
	keys = {{
		"<leader>blame",
		function()
			vim.cmd("GitBlameToggle")
		end,
    }},
}
