-- local code = require("codecompanion")
--
-- local copilot = { name = "copilot", model = "claude-opus-4.5" }
require("codecompanion").setup({
	opts = {
		interactions = {
			chat = {
				adapter = {
					name = "anthropic",
					model = "claude-haiku-4-5-20251001",
				},
			},
			inline = {
				adapter = {
					name = "anthropic",
					model = "claude-haiku-4-5-20251001",
				},
			},
		},
	},
})

-- code:setup({
-- 	display = {
-- 		diff = {
-- 			enabled = true,
-- 		},
-- 	},
-- 	interactions = {
-- 		chat = {
-- 			adapter = {
-- 				name = "anthropic",
-- 				model = "claude-haiku-4-5-20251001",
-- 			},
-- 		},
-- 		inline = {
-- 			adapter = {
-- 				name = "anthropic",
-- 				model = "claude-haiku-4-5-20251001",
-- 			},
-- 		},
-- 	},
-- 	extensions = {
-- 		mcphub = {
-- 			callback = "mcphub.extensions.codecompanion",
-- 			opts = {
-- 				make_vars = true,
-- 				make_slash_commands = true,
-- 				show_result_in_chat = true,
-- 			},
-- 		},
-- 	},
-- })
-- Keymap to toggle CodeCompanion chat
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ac", "<cmd>:CodeCompanionChat Toggle<CR>", opts)
vim.keymap.set("v", "<leader>z", ":CodeCompanion<space>", opts)
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", opts)
