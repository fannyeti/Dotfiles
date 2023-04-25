require('mason').setup({
    ui = {
        border = 'rounded'
    }
})

require('lspconfig.ui.windows').default_options.border = 'rounded'

-- LSP
local lsp = require("lsp-zero").preset({
    set_lsp_keymaps = false,
    manage_nvim_cmp = {
        use_luasnip = true,
        set_sources = 'recommended'
    }
})

lsp.ensure_installed({
    "lua_ls",
    "clangd",
	"rust_analyzer",
    "pyright",
    "gopls",
    "awk_ls",
    "bashls",
    "texlab",
    "html",
    "cssls",
	"tsserver",
    "svelte",
})

lsp.on_attach(function(client, bufnr)
    local nmap = function(keys, func)
        vim.keymap.set('n', keys, func, { buffer = bufnr, remap = false })
    end

    nmap("<leader>f", vim.lsp.buf.format)
    nmap("gd", vim.lsp.buf.definition)
    nmap("K", vim.lsp.buf.hover)
    nmap("gi", vim.lsp.buf.implementation)
    nmap("go", vim.lsp.buf.type_definition)
    nmap("<leader>vws", vim.lsp.buf.workspace_symbol)
    nmap("<leader>vss", vim.lsp.buf.document_symbol)
    nmap("<leader>vd", vim.diagnostic.open_float)
    nmap("]d", vim.diagnostic.goto_next)
    nmap("[d", vim.diagnostic.goto_prev)
    nmap("<leader>vca", vim.lsp.buf.code_action)
    nmap("<leader>vrr", vim.lsp.buf.references)
    nmap("<leader>vrn", vim.lsp.buf.rename)
end)

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

vim.diagnostic.config({
    virtual_text = false,
    float = {
        source = "always",
        border = "rounded",
        severity_sort = true,
    }
})

-- Autocompletion
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    mapping = {
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

-- Null-LS
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d.with({
            diagnostics_format = '[eslint] #{m}\n(#{c})'
        }),
    }
})

require('mason-null-ls').setup({
    ensure_installed = { "flake8", "autopep8", "eslint_d", "prettierd" },
    automatic_installation = true,
    handlers = {
    }
})
