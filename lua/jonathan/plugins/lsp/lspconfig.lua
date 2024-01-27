return {
	"neovim/nvim-lspconfig", -- in-built Neovim LSP
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- autocompletion
		"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
	},
	config = function()
		-- disable lsp logs ("off") unless needed so it doesn't create a huge file (switch to "debug" if needed)
		vim.lsp.set_log_level("off")

		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local typescript = require("typescript") -- additional functionality for tsserver (e.g. file renames & update imports)

		local keymap = vim.keymap -- for conciseness

		-- enable keybinds when lsp is available
		local on_attach = function(client, bufnr)
			-- keybind options
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- set keybinds
			keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts) -- show definition, references
			keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- go to declaration
			keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
			keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
			keymap.set("n", "<leader>ga", "<cmd>Lspsaga code_action<CR>", opts) -- go to available code actions
			keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
			keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
			keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
			keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
			keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
			keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor

			-- typescript specific keymaps (e.g. rename file and update imports)
			if client.name == "tsserver" then
				keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
				keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports
				keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
			end
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure python server
		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "python" },
			settings = {
				pyright = { autoImportCompletion = true }, -- see settings here: https://github.com/microsoft/pyright/blob/main/docs/settings.md
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
					},
				},
			}, -- could probably get it to work with pyproject.toml by overriding the "cmd" property and adding the -p flag (-p pyproject.toml)
			-- see here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
		})

		-- configure typescript server with plugin
		typescript.setup({
			server = {
				init_options = {
					-- relative imports
					preferences = {
						importModuleSpecifierPreference = "relative",
						importModuleSpecifierEnding = "minimal",
					},
				},
				capabilities = capabilities,
				on_attach = on_attach,
			},
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure bash server
		lspconfig["bashls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})

		lspconfig["eslint"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure lua server
		lspconfig["lua_ls"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME .. "/lua",
									"${3rd}/luv/library",
									"${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
								-- library = vim.api.nvim_get_runtime_file("", true),
							},
							diagnostics = {
								globals = { "vim" },
							},
						},
					})

					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
			end,
		})

		lspconfig["apex_ls"].setup({
			apex_jar_path = os.getenv("HOME") .. "/Documents/neovim/apex-jorje-lsp.jar",
			apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
			apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
			filetypes = { "apex" },
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
