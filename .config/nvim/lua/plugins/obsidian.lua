return {
	"obsidian-nvim/obsidian.nvim",
	ft = "markdown",
	version = "*",
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "Work",
				path = "~/personal/obsidian/Work",
			},
		},

		daily_notes = {
			enabled = true,
			folder = "daily",
			date_format = "YYYY-MM-DD",
			default_tags = { "journal", "daily" },
		},
	},
	keys = {
		{
			"<leader>ol",
			":Obsidian link<CR>",
			mode = "v",
			desc = "Link highlighted text to note. Open picker to find note.",
		},
	},
}
