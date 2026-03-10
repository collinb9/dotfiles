-- LSP and completion stack
-- Core editing infrastructure that loads early but can wait for first buffer

return {
	-- Mason - LSP installer (needs to load before mason-lspconfig)
	{
		"williamboman/mason.nvim",
		lazy = false, -- Load early to ensure LSP servers are available
	},

	-- Mason LSP bridge (needs mason, provides handlers for lspconfig)
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
	},

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("config.lsp")
		end,
	},

	-- LSP kind icons
	{
		"onsails/lspkind-nvim",
		lazy = true,
	},

	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind-nvim",
		},
	},

	-- Completion sources
	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = true,
	},
	{
		"hrsh7th/cmp-buffer",
		lazy = true,
	},
	{
		"hrsh7th/cmp-path",
		lazy = true,
	},
	{
		"hrsh7th/cmp-cmdline",
		lazy = true,
	},
}
