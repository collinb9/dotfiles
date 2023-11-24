require("config.opts")
require("config.remap")
require("config.plugins")
require("config.colourscheme")
require("config.telescope")
require("config.harpoon")
require("config.dadbod")
require("config.lsp")
require("config.fugitive")
require("config.treesitter")
require("config.autopairs")
require("config.conform")

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

