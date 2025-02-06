return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- autocompletion
	},
	config = function()
		-- disable lsp logs ("off") unless needed so it doesn't create a huge file (switch to "debug" if needed)
		vim.lsp.set_log_level("off")

		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- enable keybinds when lsp is available
		local on_attach = function(_, bufnr)
			-- keybind options
			local opts = function(desc)
				return { desc = desc, buffer = bufnr, noremap = true, silent = true }
			end

			-- set keybinds
			keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts("(Lspsaga) Show definition/references"))
			keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts("Go to declaration"))
			keymap.set(
				"n",
				"gd",
				"<cmd>Lspsaga peek_definition<CR>",
				opts("(Lspsaga) See definition and make edits in window")
			)
			keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts("Go to implementation"))
			keymap.set("n", "<leader>ga", "<cmd>Lspsaga code_action<CR>", opts("(Lspsaga) Show available code actions"))
			keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts("(Lspsaga) Smart rename"))
			keymap.set(
				"n",
				"<leader>D",
				"<cmd>Lspsaga show_line_diagnostics<CR>",
				opts("(Lspsaga) Show diagnostics for line")
			)
			keymap.set(
				"n",
				"<leader>d",
				"<cmd>Lspsaga show_cursor_diagnostics<CR>",
				opts("(Lspsaga) Show diagnostics for cursor")
			)
			keymap.set(
				"n",
				"[d",
				"<cmd>Lspsaga diagnostic_jump_prev<CR>",
				opts("(Lspsaga) Jump to previous diagnostic in buffer")
			)
			keymap.set(
				"n",
				"]d",
				"<cmd>Lspsaga diagnostic_jump_next<CR>",
				opts("(Lspsaga) Jump to next diagnostic in buffer")
			)
			keymap.set(
				"n",
				"K",
				"<cmd>Lspsaga hover_doc<CR>",
				opts("(Lspsaga) Show documentation for what is under cursor")
			)
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

		lspconfig["ruff"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "python" },
			cmd = { "ruff", "server", "--preview" },
		})

		-- configure typescript server with plugin
		lspconfig["ts_ls"].setup({
			init_options = {
				-- relative imports
				preferences = {
					importModuleSpecifierPreference = "relative",
					importModuleSpecifierEnding = "minimal",
				},
				plugins = {},
			},
			filetypes = {
				"javascript",
				"typescript",
				"typescriptreact",
				"javascriptreact",
				"vue",
			},
			capabilities = capabilities,
			on_attach = on_attach,
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

		lspconfig["eslint"].setup({ -- search for current issues: https://github.com/neovim/nvim-lspconfig/issues?q=is%3Aissue+eslint (this has broken with new versions of eslint-lsp in the past, downgrade with :MasonInstall eslint-lsp@<version> if needed)
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
