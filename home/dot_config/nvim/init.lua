require("init")

vim.filetype.add({ extension = { es6 = "javascript" } })
vim.filetype.add({ extension = { ejs = "html" } })


vim.keymap.set("n", "<leader>fs", function()
	require("plugins-local.aformat").format()
end, { desc = "run aformat" })
