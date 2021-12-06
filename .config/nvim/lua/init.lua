require("config.telescope")
require("config.lsp")
require("config.harpoon")
require("config.git-worktree")
require("config.nvim-terminal")
require("config.hop")

P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-------- Key bindings

-- Fugitive
opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<leader>gd', '<cmd>:G diff --cached<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gc', '<cmd>:G commit -v<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gp', '<cmd>:G push<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gl', '<cmd>:G log<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ga', '<cmd>:G add .<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gu', '<cmd>:G add -u<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gh', '<cmd>:G add %<CR>', opts)

