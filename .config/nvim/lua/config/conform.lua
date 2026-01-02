local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		yaml = { "prettierd" },
		sh = { "beautysh" },
		sql = { "sqlfmt" },
		markdown = { "prettierd" },
		toml = { "tombi" },
	},
	formatters = {
		black = { prepend_args = { "--line-length", "79" } },
	},
})

vim.keymap.set("n", "<leader>b", conform.format)
