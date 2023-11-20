-- Fugitive
opts = {noremap = true, silent = true}
vim.keymap.set('n', '<leader>gd', '<cmd>:G diff --cached<CR>', opts)
vim.keymap.set('n', '<leader>gc', '<cmd>:G commit -v<CR>', opts)
vim.keymap.set('n', '<leader>gp', '<cmd>:G push<CR>', opts)
vim.keymap.set('n', '<leader>gl', '<cmd>:G log<CR>', opts)
vim.keymap.set('n', '<leader>ga', '<cmd>:G add .<CR>', opts)
vim.keymap.set('n', '<leader>gu', '<cmd>:G add -u<CR>', opts)
vim.keymap.set('n', '<leader>gh', '<cmd>:G add %<CR>', opts)
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, opts)

