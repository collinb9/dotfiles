
require("telescope").setup({
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = " >",
        color_devicons = true,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        set_env = { ['TERM'] = vim.env.TERM },
        -- vimgrep_arguments =  {
        --     'rg', '--hidden', '--with-filename', '--linenumber', 'smart-case'
        -- }
    },
    mappings = {
        i = {
            ["<M-q>"] = require("telescope.actions").send_to_loclist + require("telescope.actions").open_loclist
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
})

require('telescope').load_extension('fzy_native')
-- require('telescope').load_extension('harpoon')

-- Key bindings

-- local ops = { noremap = true, silent = true }
local ops = {}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, ops)
vim.keymap.set('n', '<C-p>', builtin.git_files, ops)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, ops)
vim.keymap.set('n', '<leader>fq', builtin.quickfix, ops)
vim.keymap.set('n', '<leader>fl', builtin.loclist, ops)
vim.keymap.set('n', '<leader>fm', builtin.man_pages, ops)
