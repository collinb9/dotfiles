require("config.opts")
require("config.keymaps")  -- Default vim keymaps
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
require("config.lint")
require("config.comment")
require("config.codecompanion")
require("config.minidiff")
require("config.mcphub")

-- Setup utility functions
local utils = require("utils")

-- Global utility functions for debugging
P = utils.print_inspect

-- Setup reload function if plenary is available
local reload_fn = utils.setup_reload()
if reload_fn then
  RELOAD = require('plenary.reload').reload_module
  R = reload_fn
end


