local zk = require("zk")

zk.setup({
    picker = "telescope",
})

local function nmap(...) vim.api.nvim_buf_set_keymap(0, ...) end
local commands = require("zk.commands")
local opts = { silent = true, noremap = true }
local util = require("zk.util")

local function make_edit_fn(defaults, picker_options)
    return function(options)
        options = vim.tbl_extend("force", defaults, options or {})
        zk.edit(options, picker_options)
    end
end

commands.add("ZkRecents", make_edit_fn({ createdAfter = "1 weeks ago" }, { title = "Zk Recents" }))
commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
commands.add("ZkLiveGrep", function(options)
    options = options or {}
    local notebook_path = options.notebook_path or util.resolve_notebook_path(0)
    local notebook_root = util.notebook_root(notebook_path)
    if notebook_root then
        require("telescope.builtin").live_grep({ cwd = notebook_root, prompt_title = "Zk Live Grep" })
    else
        vim.notify("No notebook found", vim.log.levels.ERROR)
    end
end)

nmap("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
nmap("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)
nmap("n", "<leader>zL", "<Cmd>ZkBacklinks<CR>", opts)
nmap("n", "<leader>zs", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
nmap("n", "<leader>zS", "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>", opts)
nmap("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
nmap("v", "<leader>zm", ":'<,'>ZkMatch<CR>", opts)
nmap("n", "<leader>zr", "<Cmd>ZkRecents<CR>", opts)
nmap("n", "<leader>zo", "<Cmd>ZkOrphans<CR>", opts)
nmap("n", "<leader>zg", "<Cmd>ZkLiveGrep<CR>", opts)
