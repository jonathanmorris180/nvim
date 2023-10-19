return {
	"dracula/vim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		vim.cmd([[colorscheme dracula]])
		vim.cmd([[highlight DiffText guibg=#1d3450 guifg=#ffffff]])
	end,
}
