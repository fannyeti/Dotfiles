local zenmode = require("zen-mode")

zenmode.setup({
    window = {
        width = 86,
    },
})

vim.keymap.set("n", "<leader>zz", "<cmd>ZenMode<cr>", { silent = true })

