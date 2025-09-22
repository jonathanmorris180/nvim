return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"apex",
				"sosl",
				"soql",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"graphql",
				"bash",
				"xml",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"go",
			},
			-- auto install above language parsers
			auto_install = true,
			-- ignore_install = { "latex" }, -- uncomment if needed for imap completions (mostly needed for maths) - see :h vimtex-faq-treesitter
		})
	end,
}
