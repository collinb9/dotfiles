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

-- Typewriter mode
vim.opt.scrolloff = 999

-- Tweaks for file browsing
vim.g.netrw_banner=0
vim.g.netrw_liststyle = 3
vim.g.netrw_localrmdir='rm -r'
