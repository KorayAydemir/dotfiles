local function config()
	vim.cmd.colorscheme("gruvbox")

	--vim.cmd([[hi Comment guifg='red' ]])
	vim.cmd([[hi Comment guifg='#fddddd' ]])

	vim.g.gitblame_highlight_group = "GitBlame"
	vim.cmd([[hi GitBlame guifg='#aaaaaa' guibg=none]])

	vim.cmd([[hi StatusLine guifg='#252525' guibg='#dcdcdc']])

	vim.cmd([[hi TelescopeResultsComment guifg='#fbf1c7' guibg='#282828']])
end

return { "morhetz/gruvbox", priority = 100, config = config }
