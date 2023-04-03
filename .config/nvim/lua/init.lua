require("config.telescope")
require("config.lsp")
require("config.harpoon")
require("config.git-worktree")
require("config.hop")
require("config.fugitive")
require("config.dadbod")

-- Logs stores in ~/.cache/nvim/lsp.log
-- vim.lsp.set_log_level("debug")

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

