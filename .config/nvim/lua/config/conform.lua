local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		html = { "prettierd" },
		yaml = { "prettierd" },
		sh = { "beautysh" },
		sql = { "sqlfmt" },
		markdown = { "prettierd" },
		toml = { "tombi" },
		ocaml = { "ocamlformat" },
	},
})

vim.keymap.set("n", "<leader>b", conform.format)
