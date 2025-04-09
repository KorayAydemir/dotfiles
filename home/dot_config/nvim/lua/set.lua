vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
--vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

--vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undofile = true
vim.opt.undodir = (os.getenv("HOME") or os.getenv("USERPROFILE")) .. "/.vim/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- 0 means netrw sets the current folder as cwd, only for netrw's window.
-- 1 means netrw does not touch cwd. Meaning !touch will still create the file...
-- in the dir where you first opened vim in, instead of in the folder netrw is...
-- currently browsing.
vim.g.netrw_keepdir = 1
vim.opt.autochdir = false
vim.g.netrw_winsize = 30
vim.g.netrw_browse_split = 4
-- "I" to display the banner.
vim.g.netrw_banner = 0

vim.opt.termguicolors = true
vim.cmd("set numberwidth=1")

--vim.opt.updatetime = 1000

--vim.opt.colorcolumn = "80"

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- do not continue comment lines automatically
vim.cmd([[autocmd FileType * set formatoptions-=cro]])

vim.opt.showmode = false

vim.opt.autoread = true

vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.g.markdown_folding = 1
vim.opt.foldopen = "block,mark,percent,quickfix,search,tag,undo" --hor removed

vim.opt.mousemodel = "extend"

vim.opt.fileformats = "unix,dos"
vim.opt.fileformat = "unix"

