-- Developer tools - telescope, harpoon, conform, lint
-- These are invoked via specific commands or keymaps

return {
	-- Telescope - fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzy-native.nvim"
		},
		tag = "v0.2.1",
		keys = {
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
			{ "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git files" },
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
			{ "<leader>fq", function() require("telescope.builtin").quickfix() end, desc = "Quickfix" },
			{ "<leader>fl", function() require("telescope.builtin").loclist() end, desc = "Location list" },
			{ "<leader>fm", function() require("telescope.builtin").man_pages() end, desc = "Man pages" },
		},
		config = function()
			require("config.telescope")
		end,
	},

	-- Harpoon - quick file navigation
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>a", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
			{ "<leader>ha", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
			{ "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
			{ "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
			{ "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
			{ "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" },
			{ "<leader>5", function() require("harpoon.ui").nav_file(5) end, desc = "Harpoon file 5" },
			{ "<leader>6", function() require("harpoon.ui").nav_file(6) end, desc = "Harpoon file 6" },
			{ "<leader>7", function() require("harpoon.ui").nav_file(7) end, desc = "Harpoon file 7" },
			{ "<leader>8", function() require("harpoon.ui").nav_file(8) end, desc = "Harpoon file 8" },
			{ "<leader>9", function() require("harpoon.ui").nav_file(9) end, desc = "Harpoon file 9" },
			{ "<leader><F1>", function() require("harpoon.tmux").gotoTerminal(1) end, desc = "Harpoon tmux 1" },
			{ "<leader><F2>", function() require("harpoon.tmux").gotoTerminal(2) end, desc = "Harpoon tmux 2" },
			{ "<leader><F3>", function() require("harpoon.tmux").gotoTerminal(3) end, desc = "Harpoon tmux 3" },
			{ "<leader><F4>", function() require("harpoon.tmux").gotoTerminal(4) end, desc = "Harpoon tmux 4" },
			{ "<leader>c<F1>", function() require("harpoon.tmux").sendCommand(1, 1) end, desc = "Harpoon send 1" },
			{ "<leader>c<F2>", function() require("harpoon.tmux").sendCommand(1, 2) end, desc = "Harpoon send 2" },
			{ "<leader>c<F3>", function() require("harpoon.tmux").sendCommand(1, 3) end, desc = "Harpoon send 3" },
			{ "<leader>c<F4>", function() require("harpoon.tmux").sendCommand(1, 4) end, desc = "Harpoon send 4" },
			{ "<leader>cm", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Harpoon cmd menu" },
		},
		config = function()
			require("config.harpoon")
		end,
	},

	-- Conform - formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("config.conform")
		end,
	},

	-- Nvim-lint - linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("config.lint")
		end,
	},
}
