return {
	"nvim-lua/plenary.nvim", -- Lua functions that many other plugins depend on
	{
		"tpope/vim-surround",
		event = { "BufEnter" },
	},
	{
		"folke/which-key.nvim", -- displays a popup with possible key bindings of the command you started typing
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
	{
		"numToStr/Comment.nvim", -- commenting with "gc"
		config = true,
	},
	{ "christoomey/vim-tmux-navigator", lazy = false },
	{ "folke/neodev.nvim", opts = {} }, -- Neovim setup for init.lua and plugin development with full signature help, docs, and completion for the nvim lua API
	"mg979/vim-visual-multi",
	"mbbill/undotree",
	"tpope/vim-fugitive",
	-- makes resolving merge conflicts easy ([x maps to next conflict)
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	{ "metakirby5/codi.vim", event = { "BufEnter" } },
	{
		"rcarriga/cmp-dap",
		event = { "BufEnter" },
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
	-- live server
	{
		"barrett-ruth/live-server.nvim",
		build = "npm install --legacy-peer-deps -g live-server",
		config = true,
	},
}
