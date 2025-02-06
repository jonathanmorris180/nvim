return {
	-- note: you can lazy load plugins on certain keybinds too with the "keys" property (see :h lazy.nvim)
	{
		"nvim-lua/plenary.nvim",
		init = function()
			require("plenary.filetype").add_file("apex") -- add filetype to plenary so that telescope previewer can use it
			require("plenary.filetype").add_file("visualforce")
		end,
	}, -- Lua functions that many other plugins depend on
	-- {
	-- 	"LunarVim/bigfile.nvim", -- Could be useful for large files
	-- },
	{ "echasnovski/mini.nvim", version = "*" },
	{ "ixru/nvim-markdown" },
	{
		"z0rzi/ai-chat.nvim",
		config = function()
			require("ai-chat").setup()
		end,
	},
	{
		"tpope/vim-surround",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"zbirenbaum/copilot-cmp",
		config = true,
	},
	{
		"tpope/vim-repeat",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"folke/which-key.nvim", -- displays a popup with possible key bindings of the command you started typing
		event = "VeryLazy",
		opts = {
			delay = 2000,
		},
	},
	{ "sindrets/diffview.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "christoomey/vim-tmux-navigator", lazy = false },
	"mbbill/undotree",
	"tpope/vim-fugitive",
	-- makes resolving merge conflicts easy ([x maps to next conflict)
	{ "metakirby5/codi.vim", event = { "BufReadPre", "BufNewFile" } },
	{
		"rcarriga/cmp-dap",
		event = { "BufReadPre", "BufNewFile" },
	},
	-- java
	{ "mfussenegger/nvim-jdtls" },
	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
