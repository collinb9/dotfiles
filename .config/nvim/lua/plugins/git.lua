-- Git integration plugins

return {
	-- Fugitive - Git commands
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiff", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename" },
		keys = {
			{ "<leader>gd", "<cmd>G diff --cached<CR>", desc = "Git diff cached" },
			{ "<leader>gc", "<cmd>G commit -v<CR>", desc = "Git commit" },
			{ "<leader>gp", "<cmd>G push<CR>", desc = "Git push" },
			{ "<leader>gl", "<cmd>G log<CR>", desc = "Git log" },
			{ "<leader>ga", "<cmd>G add .<CR>", desc = "Git add all" },
			{ "<leader>gu", "<cmd>G add -u<CR>", desc = "Git add updated" },
			{ "<leader>gh", "<cmd>G add %<CR>", desc = "Git add current" },
			{ "<leader>gs", vim.cmd.Git, desc = "Git status" },
		},
	},

	-- GitGutter - Git diff signs
	{
		"airblade/vim-gitgutter",
		event = { "BufReadPost" },
		config = function()
			require("config.gitgutter")
		end,
	},
}
