require("gruvbox").setup({
    bold = false,
    transparent_mode = true,
    palette_overrides = {
        light1 = "#e2cca9",
        bright_red = "#f2594b",
        bright_green = "#b0b846",
        bright_yellow = "#e9b143",
        bright_blue = "#80aa9e",
        bright_purple = "#d3869b",
        bright_aqua = "#8bba7f",
        bright_orange = "#f28534",
    },
    overrides = {
        CursorLine = { bg = "" },
        CursorLineNr = { bg = "" },
        HopNextKey = { fg = "#f2594b" },
        HopNextKey1 = { fg = "#076678" },
        HopNextKey2 = { fg = "#458588" },
    }
})

vim.cmd("colorscheme gruvbox")

function ZenPencil()
    vim.cmd.colorscheme("acme")
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>zp", ":lua ZenPencil()<CR>", opts)
