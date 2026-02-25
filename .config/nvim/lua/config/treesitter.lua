local treesitter = require("nvim-treesitter")

treesitter.install({
	"c",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"python",
	"sql",
	"nim",
	"javascript",
	"typescript",
	"html",
	"yaml",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match) or args.match
		local installed = treesitter.get_installed("parsers")
		if vim.tbl_contains(installed, lang) then
			vim.treesitter.start(args.buf)
		end
	end,
})
