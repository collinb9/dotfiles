require("config.opts")
require("config.keymaps")  -- Default vim keymaps
require("config.remap")
require("config.plugins")
require("config.colourscheme")

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


