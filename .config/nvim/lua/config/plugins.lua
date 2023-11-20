-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.keymap.set("n", "<leader>ps", "<cmd>:PackerSync<CR>")
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	  requires = { {'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim'} }
  }

  use( 'tpope/vim-surround')
  use( 'tpope/vim-commentary')
  use( 'tpope/vim-repeat')
  use(  'tpope/vim-abolish' )
  use(  'tpope/vim-fugitive' )
  use( 'jiangmiao/auto-pairs')

  use( 'ellisonleao/gruvbox.nvim' )
  use( 'nvim-treesitter/nvim-treesitter', {run=':TSUpdate'})
  use( 'ThePrimeagen/harpoon' )

  use ('neovim/nvim-lspconfig')
  use ('onsails/lspkind-nvim')
  use ('hrsh7th/cmp-nvim-lsp')
  use ('hrsh7th/nvim-cmp')
  use ('hrsh7th/cmp-buffer')
  use ('hrsh7th/cmp-path')
  use ('hrsh7th/cmp-cmdline')

  -- Formatting
  use ( 'jose-elias-alvarez/null-ls.nvim' )
  -- Manages LSP servers
  use ('williamboman/mason.nvim', {tag = '1.8.1'})
  use ('williamboman/mason-lspconfig.nvim')

  use ('airblade/vim-gitgutter')


  use( 'tpope/vim-dadbod')
  use( 'kristijanhusak/vim-dadbod-ui')
  use( 'kristijanhusak/vim-dadbod-completion')

  -- Previously used plugins that I may want to look at again
-- use ('dense-analysis/ale')
-- use ('cespare/vim-toml')
-- use ('L3MON4D3/LuaSnip')
end)
