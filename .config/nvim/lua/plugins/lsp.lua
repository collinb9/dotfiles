-- LSP and completion stack
-- Core editing infrastructure that loads early but can wait for first buffer

return {

	-- LspSage - improved UI for interacting w/ LSP
	{
		"nvimdev/lspsaga.nvim",
		lazy = false,
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false,
				},
				finder = {
					keys = {
						shuttle = "[w",
						toggle_or_open = "<CR>",
						vsplit = "s",
						split = "i",
						quit = "q",
					},
				},
				symbol_in_winbar = {
					enable = false,
				},
				scroll_preview = {
					scroll_down = "<C-n>",
					scroll_up = "<C-p>",
				},
				rename = {
					keys = {
						quit = { "<Esc>" },
						exec = "<CR>",
						select = "x",
					},
				},
			})
		end,

		keys = {
			{
				"<leader>ca",
				":Lspsaga code_action<CR>",
				mode = { "v", "n" },
				desc = "List and select code action in picker",
				silent = true,
			},
			{
				"<leader>rn",
				":Lspsaga rename<CR>",
				mode = { "n" },
				desc = "Rename variable",
				silent = true,
			},
			{
				"gD",
				":Lspsaga peek_definition<CR>",
				mode = { "n" },
				desc = "Peek definition",
				silent = true,
			},
			{
				"<leader>z",
				":Lspsaga show_line_diagnostics<CR>",
				mode = { "n" },
				desc = "Show lsp diagnostics",
				silent = true,
			},
			{
				"<leader>f",
				":Lspsaga finder<CR>",
				mode = { "n", "v" },
				desc = "Show lsp references and implementations",
				silent = true,
			},
			{
				"K",
				":Lspsaga hover_doc<CR>",
				mode = { "n" },
				desc = "Hover window w/ documentation",
				silent = true,
			},
			{
				"<leader>t",
				":Lspsaga peek_type_definition<CR>",
				mode = { "n" },
				desc = "Peek type defininition",
				silent = true,
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- Mason - LSP installer
	{

		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
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
			"nvimdev/lspsaga.nvim",
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
