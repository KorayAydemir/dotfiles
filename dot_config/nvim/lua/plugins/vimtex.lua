local function config()
	vim.cmd([[
    filetype plugin on
    syntax enable
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0
    set conceallevel=1
    let g:tex_conceal='abdmg'
    autocmd BufRead,BufNewFile *.tex setlocal spell
    set spelllang=tr,en_gb
    ]])
	vim.g.vimtex_syntax_conceal_disable = 1
end

return {
	"lervag/vimtex",
	ft = "tex",
	config = config,
}
