vim.g.mapleader = " "
-- Lex opens in pwd dir, Vex opens in the current file's dir
vim.keymap.set("n", "<leader>pc", function() vim.cmd("Lex!") end)
vim.keymap.set("n", "<leader>pv", function() vim.cmd("Vex!") end)

-- move things around
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("x", "<leader>p", [["_dP]]) --paste to void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- delete to void register

-- replace the word you are on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>rain", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("t", "<C-[>", "<C-\\><C-N>", {})

--https://stackoverflow.com/a/17096082
-- relative path
vim.keymap.set("n", "<leader>pa", "<cmd>:let @+=@%<CR>")

-- full path
vim.keymap.set("n", "<leader>pA", '<cmd>:let @+ = expand("%:p")<CR>')

-- just filename
--:let @+ = expand("%:t")

vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<M-j>", "<C-W>+")
vim.keymap.set("n", "<M-k>", "<C-W>-")

vim.keymap.set("n", "<Leader>;", function() vim.cmd("up") end)
