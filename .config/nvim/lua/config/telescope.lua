
require("telescope").setup({
    defaults = {
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = " >",
        color_devicons = true,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- vimgrep_arguments =  {
        --     'rg', '--hidden', '--with-filename', '--linenumber', 'smart-case'
        -- }
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
require('telescope').load_extension('git_worktree')


local ops = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>f*', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols = {'class', 'method', 'function'}})<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fq', "<cmd>lua require('telescope.builtin').quickfix()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fl', "<cmd>lua require('telescope.builtin').loclist()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fm', "<cmd>lua require('telescope.builtin').man_pages()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fe', "<cmd>lua require('telescope.builtin').file_browser()<cr>", ops)


