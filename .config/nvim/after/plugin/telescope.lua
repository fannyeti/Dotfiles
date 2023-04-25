local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pg', builtin.git_files)
vim.keymap.set('n', '<leader>pf', builtin.find_files)
vim.keymap.set('n', '<leader>pF', builtin.oldfiles)
vim.keymap.set('n', '<leader>ps', builtin.live_grep)
vim.keymap.set('n', '<leader>pS', builtin.grep_string)
vim.keymap.set('n', '<leader>pb', builtin.buffers)
vim.keymap.set('n', '<leader>pdd', builtin.diagnostics)
