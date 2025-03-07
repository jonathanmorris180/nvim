return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- import gitsigns plugin safely
		local gitsigns = require("gitsigns")

		-- configure/enable gitsigns
		gitsigns.setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				vim.cmd([[highlight GitSignsCurrentLineBlame guifg=#ff0000]]) -- sets the text color so it's visible

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]gc", function() -- prevents clash with nvim-treesitter-textobjects
					if vim.wo.diff then
						return "]c" -- move to next section of diff
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "(Gitsigns) next hunk" })

				map("n", "[gc", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "(Gitsigns) previous hunk" })

				-- Actions
				-- map('n', '<leader>hs', gs.stage_hunk)
				-- map('n', '<leader>hr', gs.reset_hunk)
				-- map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
				-- map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
				-- map('n', '<leader>hS', gs.stage_buffer)
				-- map('n', '<leader>hu', gs.undo_stage_hunk)
				-- map('n', '<leader>hR', gs.reset_buffer)
				-- map('n', '<leader>td', gs.toggle_deleted)
				map("n", "<leader>gp", function()
					gs.preview_hunk()
				end, { desc = "(Gitsigns) preview hunk" })
				map("n", "<leader>gdl", function()
					gs.blame_line({ full = true })
				end, { desc = "(Gitsigns) line blame with diff" })
				map("n", "<leader>gl", function()
					gs.toggle_current_line_blame()
				end, { desc = "(Gitsigns) toggle current line blame (virtual text)" })
				map("n", "<leader>gdi", function()
					gs.diffthis()
				end, { desc = "(Gitsigns) Diff changes for current file against index" })
			end,
		})
	end,
}
