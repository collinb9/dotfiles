local nvim_lsp = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	path = "[Path]",
}

local lspkind = require("lspkind")
lspkind.init({
	mode = "symbol_text",
})

local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-e>"] = cmp.mapping.close(),
		["<tab>"] = cmp.mapping.confirm(),
	}),

	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			vim_item.menu = menu
			return vim_item
		end,
	},

	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
	},
})

-- Only map the following keys after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

local default_setup = function(server)
	nvim_lsp[server].setup({
		capabilities = lsp_capabilities,
	})
end

-- CloudFormation LSP configuration (manual installation)
-- cfn-lsp-extra provides hover, completion, and diagnostics for CloudFormation/SAM templates

-- Add cfn-lsp-extra as a custom server configuration
local configs = require("lspconfig.configs")
if not configs.cfn_lsp_extra then
	configs.cfn_lsp_extra = {
		default_config = {
			cmd = { "cfn-lsp-extra" },
			filetypes = { "yaml.cloudformation", "json.cloudformation" },
			root_dir = function(fname)
				return nvim_lsp.util.find_git_ancestor(fname) or vim.fn.getcwd()
			end,
			settings = {
				documentFormatting = false,
			},
		},
		docs = {
			description = "CloudFormation Language Server with hover, completion, and diagnostics support",
		},
	}
end

-- Setup the CloudFormation LSP server
nvim_lsp.cfn_lsp_extra.setup({
	capabilities = lsp_capabilities,
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "bashls", "jedi_language_server", "lua_ls", "sqlls" }, --"typescript-language-server" },
	automatic_installation = true,
	handlers = { default_setup },
})
