-- Text manipulation plugins
-- Load on keys or specific events

return {
	-- Surround text objects
	{
		"tpope/vim-surround",
		keys = {
			{ "ys", mode = "n" },
			{ "cs", mode = "n" },
			{ "ds", mode = "n" },
			{ "S", mode = "v" },
		},
	},

	-- Repeat plugin commands with .
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},

	-- Case-preserving substitution, abbreviations, coercion
	{
		"tpope/vim-abolish",
		cmd = { "Abolish", "Subvert", "S" },
		keys = {
			{ "cr", mode = "n" }, -- Case coercion mappings
		},
	},

	-- Comment toggling
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		},
		config = function()
			require("config.comment")
		end,
	},
}
