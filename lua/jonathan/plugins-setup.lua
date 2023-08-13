local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

local plugins = {
	{
		"dracula/vim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme dracula]])
		end,
	},
	"nvim-lua/plenary.nvim", -- Lua functions that many other plugins depend on
	"tpope/vim-surround",
	"folke/which-key.nvim",
	"numToStr/Comment.nvim", -- commenting with "gc"
	"nvim-tree/nvim-tree.lua", -- file explorer
	"nvim-tree/nvim-web-devicons", -- icons in file explorer
	"nvim-lualine/lualine.nvim", -- adds a nice status line
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- file searching
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- makes telesope perform better
	{ "christoomey/vim-tmux-navigator", lazy = false },
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",

	-----------------------------
	-- autocompletion/snippets --
	-----------------------------
	"hrsh7th/nvim-cmp", -- autocompletion
	"hrsh7th/cmp-buffer", -- provides completions from the currently open buffers
	"hrsh7th/cmp-path", -- provides completions from file paths
	-- snippets
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "2.*",
	}, -- snippet engine
	"saadparwaiz1/cmp_luasnip", -- for autocompletion
	"rafamadriz/friendly-snippets", -- useful snippets

	---------
	-- LSP --
	---------
	"williamboman/mason.nvim", -- LSP server, linter, and formatter manager
	"williamboman/mason-lspconfig.nvim", -- ties mason with nvim-lspconfig
	"neovim/nvim-lspconfig", -- configs for specific languages
	"hrsh7th/cmp-nvim-lsp", -- autocompletion
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	}, -- enhanced UI for LSPs
	"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
	"onsails/lspkind.nvim", -- icons for autocompletion
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	------------------------
	-- formatting/linting --
	------------------------
	"jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
	}, -- allows mason to use null-ls

	-- auto-close brackets
	{ "windwp/nvim-autopairs", event = "InsertEnter" },
	"windwp/nvim-ts-autotag", -- for auto-closing and renaming HTML tags

	-- gitsigns
	"lewis6991/gitsigns.nvim",
}

require("lazy").setup(plugins, opts)
