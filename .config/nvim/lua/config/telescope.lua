
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local function cross_search(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)

    -- Determine source type from prompt_title.
    -- NOTE: This relies on prompt_title matching exactly; users who retitle pickers
    -- will need to update these strings.
    local title = picker.prompt_title
    local is_find_files = (title == "Find Files")
    local is_live_grep = (title == "Live Grep")

    if not is_find_files and not is_live_grep then
        vim.notify("cross_search: unsupported picker '" .. tostring(title) .. "'", vim.log.levels.WARN)
        return
    end

    -- Collect files: prefer marks, fall back to all filtered results
    local files = {}
    local seen = {}

    local marked = picker:get_multi_selection()
    if next(marked) then
        for _, entry in ipairs(marked) do
            local path = entry.path
            if path and not seen[path] then
                seen[path] = true
                files[#files + 1] = path
            end
        end
    else
        for entry in picker.manager:iter() do
            local path = entry.path
            if path and not seen[path] then
                seen[path] = true
                files[#files + 1] = path
            end
        end
    end

    if #files == 0 then
        vim.notify("cross_search: no files to search", vim.log.levels.WARN)
        return
    end

    actions.close(prompt_bufnr)

    vim.schedule(function()
        if is_find_files then
            builtin.live_grep({ search_dirs = files })
        else
            builtin.find_files({ search_dirs = files })
        end
    end)
end

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
        mappings = {
            i = {
                ["<M-q>"] = actions.send_to_loclist + actions.open_loclist,
                ["<C-q>"] = cross_search,
            },
            n = {
                ["<C-q>"] = cross_search,
            },
        },
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

