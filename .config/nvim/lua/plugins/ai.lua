-- AI tools - CodeCompanion and MCPHub

return {
	-- CodeCompanion - AI pair programming
	{
		"olimorris/codecompanion.nvim",
		tag = "v18.7.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		keys = {
			{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle CodeCompanion chat", mode = "n" },
			{ "<leader>z", ":CodeCompanion<space>", desc = "CodeCompanion command", mode = "v" },
			{ "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to CodeCompanion chat", mode = "v" },
		},
		config = function()
			require("config.codecompanion")
		end,
	},

	-- MCPHub - MCP integration
	{
		"ravitemer/mcphub.nvim",
		build = "npm install -g mcp-hub@latest",
		cmd = { "MCPHub" },
		keys = {
			{ "<leader>ah", desc = "MCPHub" },
		},
		config = function()
			require("config.mcphub")
		end,
	},

	-- -- GitHub Copilot
	-- {
	-- 	"github/copilot.vim",
	-- 	lazy = false,
	-- },
}
