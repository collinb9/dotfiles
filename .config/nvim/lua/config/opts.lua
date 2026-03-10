vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false

-- Handle tabs correctly
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

-- CRITICAL: Set ambiwidth to prevent unicode width mismatch in WSL2/tmux
-- Forces ambiguous-width characters to be treated as single-width
vim.opt.ambiwidth = "single"

-- Configure sign column for better stability
-- "auto:2" reserves space for up to 2 signs, reduces layout shifting
vim.opt.signcolumn = "auto:2"

-- Faster diagnostic updates to reduce stale rendering
vim.opt.updatetime = 100

-- Typewriter mode
vim.opt.scrolloff = 999

-- Tweaks for file browsing
vim.g.netrw_banner=0
vim.g.netrw_liststyle = 3
vim.g.netrw_localrmdir='rm -r'
