local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- -- Conform will run multiple formatters sequentially
		python = { "black" },
		-- -- Use a sub-list to run only the first available formatter
		javascript = { "prettierd" },
		html = { "prettierd" },
		yaml = { "prettierd" },
		sh = { "beautysh" },
	},
})

vim.keymap.set("n", "<leader>b", conform.format)
