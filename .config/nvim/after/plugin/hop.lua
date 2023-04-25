require("hop").setup()
local opts = { noremap = true, silent = true }
-- word
vim.keymap.set(
    "n",
    "<leader>hw",
    "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.BEGIN})<cr>",
    opts
)
vim.keymap.set(
    "v",
    "<leader>hw",
    "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.BEGIN})<cr>",
    opts
)
vim.keymap.set(
    "o",
    "<leader>hw",
    "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.BEGIN, inclusive_jump = true })<cr>"
    ,
    opts
)
-- line
vim.keymap.set("n", "<leader>hl", ":HopLine<cr>", opts)
vim.keymap.set("v", "<leader>hl", ":HopLine<cr>", opts)
vim.keymap.set("o", "<leader>hl", ":HopLine<cr>", opts)
