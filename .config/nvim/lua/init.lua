require("config.telescope")
-- require("config.lsp")
-- require("config.harpoon")
-- require("config.git-worktree")
-- require("config.hop")
-- require("config.fugitive")
-- require("config.dadbod")
-- require("config.treesitter")
require("config.remap")
require("config.colourscheme")

-- TODO make this mapping filetype dependent
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>:! black % --line-length 79<CR>', {noremap = true, silent = true} )

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

