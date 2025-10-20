return {
	"hrsh7th/nvim-cmp", -- autocompletion
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
		"micangl/cmp-vimtex", -- autocompletion for vimtex
	},
	config = function()
		-- import nvim-cmp plugin safely for autocompletion
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local compare = require("cmp.config.compare")

		-- set keymaps for snippets
		vim.keymap.set({ "i" }, "<C-s>", function()
			luasnip.jump(1)
		end, { silent = true, desc = "(Luasnip) Jump to next [s]nippet entry" })

		-- load vs-code like snippets from plugins (e.g. friendly-snippets)
		require("luasnip/loaders/from_vscode").lazy_load()

		vim.opt.completeopt = "menu,menuone,noinsert" -- sets the way the autocompletion behaves (whether a menu appears, etc.)

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
				["<C-u>"] = cmp.mapping.select_prev_item({ count = 10 }), -- see https://github.com/hrsh7th/nvim-cmp/issues/307
				["<C-d>"] = cmp.mapping.select_next_item({ count = 10 }),
				["<C-o>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),

			-- sources for autocompletion
			-- these are ranked in order of priority (first element is highest priority)
			-- you can also set "priority" to rank results and "max_item_count" to limit the number of suggestions
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					entry_filter = function(entry, ctx)
						return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind() -- Disable snippets from the LSP
					end,
				}, -- lsp
				{ name = "buffer", keyword_length = 5 }, -- text within current buffer but only if I've already typed 5 characters
				{ name = "path" }, -- file system paths
				{ name = "luasnip", keyword_length = 4 }, -- snippets
				-- { name = "copilot" }, disable for now since it's getting annoying
				{ name = "vimtex" },
				{
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading LuaLS completions
				},
			}),
			sorting = {
				priority_weight = 2,
				comparators = { -- defaults from https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
					compare.offset, -- these come from here: https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
					compare.exact,
					-- compare.scopes,
					compare.score,
					compare.recently_used,
					compare.locality,
					compare.kind,
					compare.sort_text,
					compare.length,
					compare.order,
				},
			},
			-- configure lspkind
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
					symbol_map = { Copilot = "" },
				}),
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			enabled = function()
				return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
			end,
		})

		cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
			sources = {
				{ name = "dap" },
			},
		})
	end,
}
