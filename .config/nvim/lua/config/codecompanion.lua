local code = require("codecompanion")
code.setup({
	display = {
		diff = {
			enabled = true,
		},
	},
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				make_vars = true,
				make_slash_commands = true,
				show_result_in_chat = true,
			},
		},
	},
})

-- Keymap to toggle CodeCompanion chat
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ac", "<cmd>:CodeCompanionChat Toggle<CR>", opts)
vim.keymap.set("v", "<leader>a", ":CodeCompanion<space>", opts)
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", opts)
