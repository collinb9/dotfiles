
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
        },
		live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
		},
    },
})

require('telescope').load_extension('fzy_native')
-- require('telescope').load_extension('harpoon')

