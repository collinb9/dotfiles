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

vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>:lua require("harpoon.mark").add_file()<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>ha', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>5', ':lua require("harpoon.ui").nav_file(5)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>6', ':lua require("harpoon.ui").nav_file(6)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>7', ':lua require("harpoon.ui").nav_file(7)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>8', ':lua require("harpoon.ui").nav_file(8)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>9', ':lua require("harpoon.ui").nav_file(9)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader><F1>', ':lua require("harpoon.tmux").gotoTerminal(1)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader><F2>', ':lua require("harpoon.tmux").gotoTerminal(2)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader><F3>', ':lua require("harpoon.tmux").gotoTerminal(3)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader><F4>', ':lua require("harpoon.tmux").gotoTerminal(4)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>c<F1>', ':lua require("harpoon.tmux").sendCommand(1, 1)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>c<F2>', ':lua require("harpoon.tmux").sendCommand(1, 2)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>c<F3>', ':lua require("harpoon.tmux").sendCommand(1, 3)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>c<F4>', ':lua require("harpoon.tmux").sendCommand(1, 4)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>ca', ':lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>', {noremap = true, silent = true} )
