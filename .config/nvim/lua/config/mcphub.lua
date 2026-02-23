require("mcphub"):setup()

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ah", "<cmd>:MCPHub<CR>", opts)
