local nvim_lsp = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	path = "[Path]",
}

local lspkind = require("lspkind")
lspkind.init({
    mode = 'symbol_text'
})

local cmp = require("cmp")
cmp.setup({
	-- snippet = {
	-- 	expand = function(args)
	-- 		-- For `vsnip` user.
	-- 		-- vim.fn["vsnip#anonymous"](args.body)

	-- 		-- For `luasnip` user.
	-- 		require("luasnip").lsp_expand(args.body)

	-- 		-- For `ultisnips` user.
	-- 		-- vim.fn["UltiSnips#Anon"](args.body)
	-- 	end,
	-- },
	-- 
	mapping = cmp.mapping.preset.insert({

		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-e>'] = cmp.mapping.close(),
		['<tab>'] = cmp.mapping.confirm()
		-- ['<tab>'] = cmp.mapping({
		-- 	i = cmp.mapping.confirm{beahavior = cmp.ConfirmBehavior.Replace, select = true},
		-- 	c = cmp.mapping.confirm{beahavior = cmp.config.disable,},
		-- }),
	}),

	formatting = {
	    format = function(entry, vim_item)
	        vim_item.kind = lspkind.presets.default[vim_item.kind]
	        local menu = source_mapping[entry.source.name]
	        vim_item.menu = menu
	        return vim_item
	    end
	    -- format = lspkind.cmp_format({
	    --     mode = 'symbol',
	    --     maxwidth = 50,
	    -- })
	},

	sources = {
		{ name = "nvim_lsp" },

		-- -- -- { name = 'vsnip' },

		-- -- { name = "luasnip" },

		-- -- -- { name = 'ultisnips' },

		-- -- { name = "vim-dadbod-completion" },
		{ name = "path" },
		{ name = "buffer" }
	}
})


-- Only map the following keys after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		local opts= {buffer = event.buf}
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		vim.keymap.set('v', '<leader>ca', "<cmd>'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
		vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		vim.keymap.set('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
		vim.keymap.set('n', '<leader>b', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	end

}
)

local default_setup = function(server)
  nvim_lsp[server].setup({
    capabilities = lsp_capabilities,
  })
end


require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {'bashls', 'jedi_language_server', 'lua_ls', 'tsserver'},
	automatic_installation = true,
	handlers = {default_setup},
})

