local opts = {
	"*", -- Highlight all files, but customize some others.
	css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
	html = { names = true }, -- Disable parsing "names" like Blue or Gray
}

return {
	"norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
	opts = opts,
}
