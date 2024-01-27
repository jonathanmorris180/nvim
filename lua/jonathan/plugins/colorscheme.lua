local current_scheme = "kanagawa"
local M = {}

M.dracula = {
	"dracula/vim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		vim.cmd([[colorscheme dracula]])
		vim.cmd([[highlight DiffText guibg=#1d3450 guifg=#ffffff]])
	end,
}

M.kanagawa = {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme kanagawa]])
	end,
}

M.nightfox = {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nightfox").setup({
			options = {
				colorblind = {
					enable = true,
					severity = {
						protan = 0.5, -- tested from here: https://daltonlens.org/evaluating-cvd-simulation/#Generating-Ishihara-like-plates-for-self-evaluation
						deutan = 1,
						tritan = 0.3,
					},
				},
			},
		})
		vim.cmd([[colorscheme nightfox]])
	end,
}

M.catppuccin = {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		require("catppuccin").setup({})
		vim.cmd([[colorscheme catppuccin-mocha]])
	end,
}

return M[current_scheme]
