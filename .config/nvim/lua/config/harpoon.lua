
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
vim.api.nvim_set_keymap('n', '<leader><F1>', ':lua require("harpoon.term").gotoTerminal(1)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader><F2>', ':lua require("harpoon.term").gotoTerminal(2)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>cu', ':lua require("harpoon.term").sendCommand(1, 1)<CR>', {noremap = true, silent = true} )
vim.api.nvim_set_keymap('n', '<leader>ce', ':lua require("harpoon.term").sendCommand(1, 2)<CR>', {noremap = true, silent = true} )


