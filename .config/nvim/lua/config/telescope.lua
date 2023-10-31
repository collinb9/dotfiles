
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
require('telescope').load_extension('git_worktree')
require('telescope').load_extension('harpoon')

-- Key bindings

local ops = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>f*', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fs', "<cmd>lua require('telescope.builtin').lsp_document_symbols({symbols = {'class', 'method', 'function'}})<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fq', "<cmd>lua require('telescope.builtin').quickfix()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fl', "<cmd>lua require('telescope.builtin').loclist()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fj', "<cmd>lua require('telescope.builtin').jumplist()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fm', "<cmd>lua require('telescope.builtin').man_pages()<cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>fe', "<cmd>lua require('telescope.builtin').file_browser()<cr>", ops)

-- git-worktree key bindings
vim.api.nvim_set_keymap('n', '<leader>gw', "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees() <cr>", ops)
vim.api.nvim_set_keymap('n', '<leader>gn', "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>", ops)
