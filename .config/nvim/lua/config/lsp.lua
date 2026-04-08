local nvim_lsp = require("lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

-- Configure diagnostics with simpler signs to avoid rendering artifacts
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.INFO] = "I",
			[vim.diagnostic.severity.HINT] = "H",
		},
	},
	virtual_text = {
		prefix = "●", -- Simple bullet instead of complex unicode
	},
	update_in_insert = false, -- Reduce rendering updates
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
		{
			name = "nvim_lsp",
			option = {
				markdown_oxide = {
					keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
				},
			},
		},
		{ name = "vim-dadbod-completion" },
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
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

local default_setup = function(server)
	nvim_lsp[server].setup({
		capabilities = lsp_capabilities,
	})
end

-- Configure custom server configurations
local configs = require("lspconfig.configs")
-- cfn-lsp-extra
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
-- Setup the LSP server
nvim_lsp.cfn_lsp_extra.setup({
	capabilities = lsp_capabilities,
})

-- ocaml
if not configs.ocamllsp then
	configs.ocamllsp = {
		default_config = {
			cmd = { "ocamllsp" },
			filetypes = { "ocaml" },
			root_markers = { "dune-project" },
			root_dir = function(fname)
				return nvim_lsp.util.find_git_ancestor(fname) or vim.fn.getcwd()
			end,
		},
	}
end
-- Setup the LSP server
nvim_lsp.ocamllsp.setup({
	capabilities = lsp_capabilities,
})

-- markdown
-- Use the function call form to MERGE (not replace) the config
vim.lsp.config("markdown_oxide", {
	-- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
	-- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
	capabilities = vim.tbl_deep_extend("force", lsp_capabilities, {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	}),
})
vim.lsp.enable("markdown_oxide")

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "bashls", "lua_ls" },
	automatic_installation = true,
	handlers = { default_setup },
})
