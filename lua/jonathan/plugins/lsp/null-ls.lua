return {
	"nvimtools/none-ls.nvim", -- configure formatters & linters
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		if vim.g.started_by_firenvim == true then
			return
		end
		local null_ls = require("null-ls")

		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- format on save (from null_ls docs)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- prevents the "Invalid server name 'null-ls'" when using the built-in vim.lsp API
		vim.lsp.config["null-ls"] = {
			cmd = {},
			---@diagnostic disable-next-line: undefined-field
			root_markers = { vim.uv.cwd() },
		}

		-- configure null_ls
		null_ls.setup({
			-- setup formatters & linters
			debug = false,
			sources = {
				--  to disable file types use
				--  "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
				require("none-ls.diagnostics.flake8"), -- Use this for projects using flake8 to make diagnostics appear
				diagnostics.mypy, -- python type checking (pyright doesn't provide as many type-checking features, so both should be enabled)
				formatting.black, -- python formatting
				formatting.sql_formatter.with({ -- install with Mason or npm -g (see https://github.com/sql-formatter-org/sql-formatter#readme)
					extra_args = { "--config", '{"language": "postgresql", "tabWidth": 2, "keywordCase": "upper"}' },
				}),
				formatting.prettier.with({
					extra_filetypes = { "apex" },
				}), -- js/ts/apex formatter
				formatting.stylua, -- lua formatter
				formatting.ktlint,
				diagnostics.ktlint, -- kotlin linter with built-in formatter
				diagnostics.pmd.with({
					filetypes = { "apex" },
					condition = function(utils)
						local result = utils.root_has_file("rulesets/apex/pmd-apex-ruleset.xml") -- doesn't work with git worktree unfortunately
						return result
					end,
					args = function(params)
						return {
							"--format",
							"json",
							"--rulesets",
							"rulesets/apex/pmd-apex-ruleset.xml", -- path to ruleset in sfdx-spotifyb2b
							"--dir",
							params.bufname,
							"--cache",
							vim.fn.stdpath("cache") .. "/pmd-cache",
						}
					end,
				}),
			},
			-- configure format on save
			on_attach = function(current_client, bufnr)
				local utils = require("jonathan.core.utils")
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
							if utils.is_obsidian_vault() then
								utils.format_bullet_list() -- format bullet list for Obsidian
							end
						end,
					})
				end
			end,
		})
	end,
}
