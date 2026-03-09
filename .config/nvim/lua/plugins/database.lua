-- Database tools - vim-dadbod family

return {
	-- Dadbod - database interface
	{
		"tpope/vim-dadbod",
		cmd = { "DB", "DBUI" },
	},

	-- Dadbod UI - visual database interface
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle Database UI" },
		},
	},

	-- Dadbod completion - integrate with nvim-cmp
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod", "hrsh7th/nvim-cmp" },
		ft = { "sql", "mysql", "plsql" },
	},
}
