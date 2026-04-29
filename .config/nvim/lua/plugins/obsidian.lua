return {
	{
		"obsidian-nvim/obsidian.nvim",
		ft = "markdown",
		version = "*",
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "Work",
					path = "~/personal/obsidian/Work",
				},
				{
					name = "Agents",
					path = "~/personal/obsidian/Agents",
				},
				{
					name = "Personal",
					path = "~/personal/obsidian/Personal",
				},
			},

			daily_notes = {
				enabled = true,
				folder = "daily",
				date_format = "YYYY-MM-DD",
				default_tags = { "daily" },
			},
			checkbox = {
				enabled = true,
				create_new = true,
				order = { " ", "x" },
			},

			templates = {
				enabled = true,
				folder = "_templates",
			},

			frontmatter = {
				enabled = function(path)
					if tostring(path):find("_templates") then -- disables the frontmatter for templates
						return false
					end
					return true
				end,
			},
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		preview = { enable = false },
	},
}
