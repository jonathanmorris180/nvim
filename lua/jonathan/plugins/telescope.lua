-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

-- import telescope actions safely
local state_setup, state = pcall(require, "telescope.state")
if not state_setup then
	return
end

-- import telescope actions safely
local action_set_setup, action_set = pcall(require, "telescope.actions.set")
if not action_set_setup then
	return
end

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
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
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
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
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
