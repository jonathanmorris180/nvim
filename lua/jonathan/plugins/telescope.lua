return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- makes telesope perform better
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local state = require("telescope.state")
		local action_set = require("telescope.actions.set")

		-- configure telescope
		telescope.setup({
			-- configure custom mappings
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-l>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
						["<C-c>"] = actions.close,
						["<C-]>"] = actions.cycle_history_next,
						["<C-[>"] = actions.cycle_history_prev,
						["<C-d>"] = function(prompt_bufnr)
							local results_win = state.get_status(prompt_bufnr).results_win
							local height = vim.api.nvim_win_get_height(results_win)
							action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
						end,
						["<C-u>"] = function(prompt_bufnr)
							local results_win = state.get_status(prompt_bufnr).results_win
							local height = vim.api.nvim_win_get_height(results_win)
							action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
						end,
					},
					n = {
						["<C-c>"] = actions.close,
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-]>"] = actions.cycle_history_next,
						["<C-[>"] = actions.cycle_history_prev,
						["<C-d>"] = function(prompt_bufnr)
							local results_win = state.get_status(prompt_bufnr).results_win
							local height = vim.api.nvim_win_get_height(results_win)
							action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
						end,
						["<C-u>"] = function(prompt_bufnr)
							local results_win = state.get_status(prompt_bufnr).results_win
							local height = vim.api.nvim_win_get_height(results_win)
							action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
						end,
					},
				},
				path_display = {
					"shorten",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")
		telescope.load_extension("git_worktree")
		local function is_valid_for_worktree()
			local utils = require("jonathan.core.utils")
			if not utils.is_worktree() then
				vim.notify("Not in bare repository", vim.log.levels.ERROR)
				return false
			end
			if utils.is_submodule() then
				vim.notify("Cannot create worktree with submodules", vim.log.levels.ERROR)
				return false
			end
			return true
		end
		local function find_worktree()
			local continue = is_valid_for_worktree()
			if not continue then
				return
			end
			local worktree = require("telescope").extensions.git_worktree
			worktree.git_worktrees()
		end
		local function create_worktree()
			local continue = is_valid_for_worktree()
			if not continue then
				return
			end
			local worktree = require("telescope").extensions.git_worktree
			worktree.create_git_worktree()
		end

		-- keymaps
		local keymap = vim.keymap
		-- <C-q> opens the current files in the quickfix list (already mapped)
		keymap.set(
			"n",
			"<C-f>",
			"<CMD>Telescope find_files<CR>",
			{ desc = "(Telescope) Find files within current working directory, respects .gitignore" }
		)
		keymap.set(
			"n",
			"<leader>fs",
			"<CMD>Telescope live_grep<CR>",
			{ desc = "(Telescope) Find string in current working directory" }
		)
		keymap.set(
			"n",
			"<leader>fc",
			"<CMD>Telescope grep_string<CR>",
			{ desc = "(Telescope) Find string under cursor in current working directory" }
		)
		keymap.set(
			"n",
			"<leader>fb",
			"<CMD>Telescope buffers sort_mru=true<CR>",
			{ desc = "(Telescope) Search most recently used open buffers" }
		)
		keymap.set(
			"n",
			"<leader>fh",
			"<CMD>Telescope help_tags<CR>",
			{ desc = "(Telescope) Search available help tags" }
		)
		keymap.set(
			"n",
			"<leader>fk",
			"<CMD>Telescope keymaps<CR>",
			{ desc = "(Telescope) Search available key mappings (!)" }
		)
		keymap.set(
			"n",
			"<leader>fg",
			":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			{ desc = "(Telescope) Live grep args telescope extension" }
		)
		keymap.set(
			"n",
			"<leader>fr",
			"<CMD>Telescope resume<CR>",
			{ desc = "(Telescope) Resume the previous telescope search" }
		)
		keymap.set(
			"n",
			"<leader>fw",
			find_worktree,
			{
				desc = "(Telescope) Find git worktree (<C-d> deletes a worktree, <C-f> toggles forcing of next deletion)",
			}
		)
		keymap.set("n", "<leader>fn", create_worktree, { desc = "(Telescope) Create git worktree" })
	end,
}
