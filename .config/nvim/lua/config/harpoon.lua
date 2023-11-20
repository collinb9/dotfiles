require("harpoon").setup({
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = false,

    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,

    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = true,

    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,

    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },

    -- set marks specific to each git branch inside git repository
    mark_branch = false,

    -- enable tabline with harpoon marks
    tabline = false,
    tabline_prefix = "   ",
    tabline_suffix = "   ",
    global_settings = {
        enter_on_sendcmd = true,
    }
})

-- local ops = { noremap = true, silent = true }
local ops = {noremap = true, silent = true}

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
local tmux = require('harpoon.tmux')
local cmdui = require('harpoon.cmd-ui')

-- vim.keymap.set('n', '<leader>ff', builtin.find_files, ops)
-- vim.keymap.set('n', '<C-p>', builtin.git_files, ops)
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, ops)
-- vim.keymap.set('n', '<leader>fq', builtin.quickfix, ops)
-- vim.keymap.set('n', '<leader>fl', builtin.loclist, ops)
-- vim.keymap.set('n', '<leader>fm', builtin.man_pages, ops)

vim.keymap.set('n', '<leader>a', mark.add_file, ops )
vim.keymap.set('n', '<leader>ha', ui.toggle_quick_menu, ops )
vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, ops )
vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, ops )
vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, ops )
vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, ops )
vim.keymap.set('n', '<leader>5', function() ui.nav_file(5) end, ops )
vim.keymap.set('n', '<leader>6', function() ui.nav_file(6) end, ops )
vim.keymap.set('n', '<leader>7', function() ui.nav_file(7) end, ops )
vim.keymap.set('n', '<leader>8', function() ui.nav_file(8) end, ops )
vim.keymap.set('n', '<leader>9', function() ui.nav_file(9) end, ops )
vim.keymap.set('n', '<leader><F1>', function() tmux.gotoTerminal(1) end, ops )
vim.keymap.set('n', '<leader><F2>', function() tmux.gotoTerminal(2) end, ops )
vim.keymap.set('n', '<leader><F3>', function() tmux.gotoTerminal(3) end, ops )
vim.keymap.set('n', '<leader><F4>', function() tmux.gotoTerminal(4) end, ops )
vim.keymap.set('n', '<leader>c<F1>', function() tmux.sendCommand(1 , 1) end, ops )
vim.keymap.set('n', '<leader>c<F2>', function() tmux.sendCommand(1 , 2) end, ops )
vim.keymap.set('n', '<leader>c<F3>', function() tmux.sendCommand(1 , 3) end, ops )
vim.keymap.set('n', '<leader>c<F4>', function() tmux.sendCommand(1 , 4) end, ops )
vim.keymap.set('n', '<leader>cm', cmdui.toggle_quick_menu, ops )
