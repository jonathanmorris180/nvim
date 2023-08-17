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
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		vim.cmd([[colorscheme tokyonight-night]])
	-- 	end,
	{
		"dracula/vim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			vim.cmd([[colorscheme dracula]])
			-- if altering defaults are needed (also see docs here: https://github.com/folke/tokyonight.nvim)
			-- vim.cmd([[highlight DiffAdd guibg=#631d18 guifg=white]])
			vim.cmd([[highlight DiffText guibg=#1d3450 guifg=#ffffff]])
		end,
	},
	"nvim-lua/plenary.nvim", -- Lua functions that many other plugins depend on
	"tpope/vim-surround",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
	"numToStr/Comment.nvim", -- commenting with "gc"
	"nvim-tree/nvim-tree.lua", -- file explorer
	"nvim-tree/nvim-web-devicons", -- icons in file explorer
	"nvim-lualine/lualine.nvim", -- adds a nice status line
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
	}, -- file searching
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
	-- multiline cursors
	"mg979/vim-visual-multi",
	"mbbill/undotree",
	-- provides :Git commands
	"tpope/vim-fugitive",

	-- makes resolving merge conflicts easy ([x maps to next conflict)
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	{ "metakirby5/codi.vim" },
	{
		"theprimeagen/harpoon",
		config = function()
			require("harpoon").setup()
			vim.keymap.set("n", "<leader>ha", require("harpoon.mark").add_file, { desc = "[H]arpoon [A]dd file" })
			vim.keymap.set(
				"n",
				"<leader>ht",
				require("harpoon.ui").toggle_quick_menu,
				{ desc = "[H]arpoon [T]oggle quick menu" }
			)
			vim.keymap.set("n", "<C-o>", require("harpoon.ui").nav_next)
			vim.keymap.set("n", "<C-p>", require("harpoon.ui").nav_prev)
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"rmagatti/auto-session",
		lazy = true,
		config = function()
			print("starting auto-session")
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})
		end,
		init = function()
			-- taken from: https://github.com/rmagatti/auto-session/issues/223
			local autocmd = vim.api.nvim_create_autocmd

			local lazy_did_show_install_view = false

			local function auto_session_restore()
				-- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
				vim.schedule(function()
					require("auto-session").AutoRestoreSession()
				end)
			end

			autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					local lazy_view = require("lazy.view")

					if lazy_view.visible() then
						-- if lazy view is visible do nothing with auto-session
						lazy_did_show_install_view = true
					else
						-- otherwise load (by require'ing) and restore session
						auto_session_restore()
					end
				end,
			})

			autocmd("WinClosed", {
				pattern = "*",
				callback = function(ev)
					local lazy_view = require("lazy.view")

					-- if lazy view is currently visible and was shown at startup
					if lazy_view.visible() and lazy_did_show_install_view then
						-- if the window to be closed is actually the lazy view window
						if ev.match == tostring(lazy_view.view.win) then
							lazy_did_show_install_view = false
							auto_session_restore()
						end
					end
				end,
			})
		end,
	},
	-- debugging
	"mfussenegger/nvim-dap",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
	{
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
	-- java
	{ "mfussenegger/nvim-jdtls" },
}

require("lazy").setup(plugins, opts)
