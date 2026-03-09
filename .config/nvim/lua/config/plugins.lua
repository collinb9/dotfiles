-- require("config.lazy")
-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" },
			tag = "v0.2.1",
		},
		{ "tpope/vim-surround" },
		{ "tpope/vim-repeat" },
		{ "tpope/vim-abolish" },
		{ "tpope/vim-fugitive" },
		{ "numToStr/Comment.nvim" },
		{ "windwp/nvim-autopairs" },
		{ "ellisonleao/gruvbox.nvim" },
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			branch = "main",
			dependencies = { "windwp/nvim-ts-autotag", "nvim-treesitter/nvim-treesitter-textobjects" },
		},
		{ "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "neovim/nvim-lspconfig" },
		{ "onsails/lspkind-nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "stevearc/conform.nvim" },
		{ "mfussenegger/nvim-lint" },
		{
			"olimorris/codecompanion.nvim",
			tag = "v18.7.0",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		},
		{ "ravitemer/mcphub.nvim", build = "npm install -g mcp-hub@latest" },
		{ "github/copilot.vim" },
		{ "airblade/vim-gitgutter" },
		{ "tpope/vim-dadbod" },
		{ "kristijanhusak/vim-dadbod-ui" },
		{ "kristijanhusak/vim-dadbod-completion" },
		{ "nvim-mini/mini.diff" },
	},
})
