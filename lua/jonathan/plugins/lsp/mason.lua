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
			automatic_enable = false,
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"jdtls",
				"emmet_ls",
				-- "apex_ls", (removing for now since it's not yet supported by Neovim core and also isn't supported by nvim-lspconfig)
				"pyright", -- Provides go to definition (ruff doesn't support this yet)
				"bashls",
				"kotlin_language_server",
				"eslint",
				"sqlls",
				"ruff", -- python all-in-one - needs to be used in conjunction with pyright for now due to incomplete features
			},
			-- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed. This is NOT the same as ensure_installed since that's just a static list.
			automatic_installation = true,
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
