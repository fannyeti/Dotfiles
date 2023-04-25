require("fannyeti.options")
require("fannyeti.keymaps")

-- yank hl
local augroup = vim.api.nvim_create_augroup
local fannyetiGroup = augroup('fannyeti', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = fannyetiGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

-- netrw
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 30

-- statusline
vim.api.nvim_create_autocmd({ 'DiagnosticChanged' }, {
    callback = function()
        local count = {}
        local levels = {
            errors = "Error",
            warnings = "Warn",
            info = "Info",
            hints = "Hint",
        }

        for k, level in pairs(levels) do
            count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
        end

        local errors = ""
        local warnings = ""
        local hints = ""
        local info = ""

        if count["errors"] ~= 0 then
            errors = "E:" .. count["errors"]
        end
        if count["warnings"] ~= 0 then
            warnings = " W:" .. count["warnings"]
        end
        if count["hints"] ~= 0 then
            hints = " H:" .. count["hints"]
        end
        if count["info"] ~= 0 then
            info = " I:" .. count["info"]
        end

        vim.b.diag = errors .. warnings .. hints .. info
    end
})

vim.opt.statusline =
[[[%{%v:lua.string.upper(v:lua.vim.fn.mode())%}] %t%-m %= %{get(b:, "diag", "")} %([%l/%L%)]%4p%%]]
