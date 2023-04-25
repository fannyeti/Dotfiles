-- vimtex
vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_latexmk = {
    build_dir = '.out',
}

-- vimmd
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_toml_frontmatter = 1
vim.g.vim_markdown_json_frontmatter = 1

--mdprev
vim.g.mkdp_theme = "light"

--vimr
vim.cmd([[
autocmd TermOpen * setlocal nonu nornu
let R_rconsole_width = 0
let rout_follow_colorscheme = 1
let R_auto_start=1
]])
