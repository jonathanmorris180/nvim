return {
	"jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- format on save (from null_ls docs)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- configure null_ls
		null_ls.setup({
			-- setup formatters & linters
			sources = {
				--  to disable file types use
				--  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
				diagnostics.mypy, -- python
				diagnostics.ruff, -- python
				formatting.black, -- python
				formatting.prettier.with({
					extra_filetypes = { "apex" },
				}), -- js/ts/apex formatter
				formatting.stylua, -- lua formatter
				diagnostics.eslint_d.with({ -- js/ts linter
					-- only enable eslint if root has .eslintrc.js
					condition = function(utils)
						return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
					end,
				}),
				diagnostics.pmd.with({
					filetypes = { "apex" },
					condition = function(utils)
						return utils.root_has_file("rulesets/apex/pmd-apex-ruleset.xml")
					end,
					args = function(params)
						return {
							"--format",
							"json",
							"--rulesets",
							"rulesets/apex/pmd-apex-ruleset.xml", -- path to ruleset in sfdx-spotifyb2b
							"--dir",
							params.bufname,
						}
					end,
				}),
			},
			-- configure format on save
			on_attach = function(current_client, bufnr)
				if current_client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								filter = function(client)
									--  only use null-ls for formatting instead of lsp server
									return client.name == "null-ls"
								end,
								bufnr = bufnr,
								timeout_ms = 3000, -- add because apex prettier formatting is slow
							})
						end,
					})
				end
			end,
		})
	end,
}
