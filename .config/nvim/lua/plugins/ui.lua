-- UI plugins that load at startup
-- These provide essential infrastructure or visual elements needed immediately

return {
	-- Colorscheme - needed immediately for UI
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000, -- Load before other plugins
	},

	-- Treesitter - syntax highlighting infrastructure
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-textobjects"
		},
		config = function()
			require("config.treesitter")
		end,
	},

	-- Autopairs - insert mode functionality, integrates with cmp
	{
		"windwp/nvim-autopairs",
		lazy = false,
		config = function()
			require("config.autopairs")
		end,
	},

	-- Git diff signs in sign column
	{
		"nvim-mini/mini.diff",
		lazy = false,
		config = function()
			require("config.minidiff")
		end,
	},
}
