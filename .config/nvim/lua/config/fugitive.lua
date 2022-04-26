-- Fugitive
opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>:G diff --cached<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>:G commit -v<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gp', '<cmd>:G push<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>:G log<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ga', '<cmd>:G add .<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gu', '<cmd>:G add -u<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gh', '<cmd>:G add %<CR>', opts)

