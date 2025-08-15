return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- autocompletion
	},
	config = function()
		-- disable lsp logs ("off") unless needed so it doesn't create a huge file (switch to "debug" if needed)
		vim.lsp.set_log_level("off")

		local lspconfig = require("lspconfig")
		local lspconfig_util = require("lspconfig.util")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		-- First param is the client - it has all the properties from :h lsp-client
		local on_attach = function(client, bufnr)
			-- keybind options
			local opts = function(desc)
				return { desc = desc, buffer = bufnr, noremap = true, silent = true }
			end

			-- set keybinds
			keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts("(Lspsaga) Show definition/references"))
			keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts("Go to declaration"))
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
			keymap.set("n", "<leader>[d", vim.diagnostic.goto_prev, opts("Go to previous diagnostic (builtin)"))
			keymap.set("n", "<leader>]d", vim.diagnostic.goto_next, opts("Go to next diagnostic (builtin)"))
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
		-- See https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#capabilities
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

		lspconfig["java_language_server"].setup({
			cmd = { vim.fn.stdpath("data") .. "/mason/packages/java-language-server/java-language-server" },
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "java" },
			root_dir = lspconfig_util.root_pattern("BUILD.bazel"),
		})

		-- Leaving this here as an example for a future migration...
		-- NOTE: This resulted in an "Invalid server name 'null-ls'" error since the native lsp tried to manage null-ls as an actual LSP
		-- This means that when I migrate over eventually I'll probably have to also move to conform.nvim and nvim-lint as a replacemnt
		-- since that's what most people seem to be using
		--
		----------------------------------------------
		-- set native log levels for LSP
		-- vim.lsp.set_log_level("DEBUG")
		-- configure java-language-server with native LSP APIs
		-- vim.lsp.config.java_language_server = {
		-- 	cmd = { vim.fn.stdpath("data") .. "/mason/packages/java-language-server/java-language-server" },
		-- 	capabilities = capabilities,
		-- 	filetypes = { "java" },
		-- 	root_dir = function(_, on_dir)
		-- 		-- If no BUILD.bazel is found, the server will not be activated
		-- 		local root = vim.fs.root(0, "BUILD.bazel")
		--
		-- 		if root then
		-- 			on_dir(root)
		-- 		end
		-- 	end,
		-- }
		-- vim.lsp.enable("java_language_server")
		----------------------------------------------

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					return
				end

				-- Set up keymaps for kotlin.nvim
				if client.name == "kotlin_ls" then
					on_attach(client, vim.api.nvim_get_current_buf())
				end
			end,
		})

		-- configure python server
		if not vim.g.started_by_firenvim == true then
			lspconfig["pyright"].setup({ -- Can be customized with pyproject.toml or pyrightconfig.json (see https://github.com/microsoft/pyright/blob/main/docs/configuration.md)
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "python" },
				settings = { -- see settings here: https://github.com/microsoft/pyright/blob/main/docs/settings.md
					python = {
						analysis = {
							autoImportCompletions = true,
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			})

			-- Pyright can't be replaced with this yet since it doesn't have all LSP features (like go to definition)
			-- This is still useful for linting issues though
			lspconfig["ruff"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "python" },
				cmd = { "ruff", "server" },
			})
		end

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
			apex_jar_path = vim.fn.stdpath("data")
				.. "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar",
			apex_enable_semantic_errors = false, -- Whether to allow Apex Language Server to surface semantic errors
			apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
			filetypes = { "apex" },
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
