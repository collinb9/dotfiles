require("config.telescope")
require("config.lsp")
require("config.harpoon")
require("config.git-worktree")
require("config.nvim-terminal")

-- Not sure what this is doing
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


