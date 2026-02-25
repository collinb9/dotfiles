-- Utility functions for Neovim configuration

local M = {}

-- Print inspection utility
function M.print_inspect(v)
  print(vim.inspect(v))
  return v
end

-- Reload module utility (requires plenary)
function M.setup_reload()
  if pcall(require, 'plenary') then
    local reload = require('plenary.reload').reload_module
    
    return function(name)
      reload(name)
      return require(name)
    end
  end
  return nil
end

return M