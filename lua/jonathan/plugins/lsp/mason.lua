return {
	"williamboman/mason.nvim", -- LSP server, linter, and formatter manager
	dependencies = {
		"williamboman/mason-lspconfig.nvim", -- ties mason with nvim-lspconfig
		"jay-babu/mason-null-ls.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		-- import mason plugin safely
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_null_ls = require("mason-null-ls")
		local mason_nvim_dap = require("mason-nvim-dap")

		-- enable mason
		mason.setup()

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"jdtls",
				"emmet_ls",
				"apex_ls",
				"bashls",
				"eslint",
				"pyright",
				"sqlls",
				"sql-formatter",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_nvim_dap.setup({
			-- list of dap adapters for mason to install
			ensure_installed = {
				"java-test",
				"java-debug-adapter",
			},
			automatic_installation = true,
		})

		mason_null_ls.setup() -- source of truth is null-ls so not adding here (see https://github.com/jay-babu/mason-null-ls.nvim?tab=readme-ov-file#primary-source-of-truth-is-mason-null-ls)
	end,
}
