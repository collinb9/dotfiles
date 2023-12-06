local lint = require("lint")

lint.linters_by_ft = {
	python = { "pylint" },
	cloudformation = { "cfn-lint" },
	lua = { "luacheck" },
	javascript = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		lint.try_lint()
	end,
})

-- Send diagnostics to
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		vim.diagnostic.setqflist({ open = false })
	end,
})
