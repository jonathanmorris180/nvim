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

require("lazy").setup({ { import = "jonathan.plugins" }, { import = "jonathan.plugins.lsp" } }, {
	install = {
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "catppuccin" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	dev = {
		path = vim.fn.expand("$HOME/Documents/repos"),
		fallback = false,
	},
	change_detection = {
		notify = false,
	},
	rocks = { -- installs hererocks into vim.fn.stdpath("data") .. "/lazy-rocks", see https://lazy.folke.io/configuration (for image.nvim)
		hererocks = true,
	},
})
