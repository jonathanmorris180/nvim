return {
	"nvim-tree/nvim-tree.lua", -- file explorer
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- icons in file explorer
	config = function()
		local nvimtree = require("nvim-tree")

		-- some settings that used to be set on vim.g have been moved to setup: https://github.com/nvim-tree/nvim-tree.lua/issues/674

		-- recommended settings
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- partially inspired by: https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#modify-you-on_attach-function-to-have-ability-to-operate-multiple-files-at-once
		-- didn't implement all the methods since bulk actions are supported out of the box (bm = bulk move, bd = bulk delete, bt = bulk trash)
		nvimtree.setup({
			renderer = {
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
				group_empty = true,
			},
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				local opts = function(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				local mark_copy = function()
					local marks = api.marks.list()
					if #marks == 0 then
						table.insert(marks, api.tree.get_node_under_cursor())
					end
					for _, node in pairs(marks) do
						api.fs.copy.node(node)
					end
					api.marks.clear()
					api.tree.reload()
				end
				local mark_move_j = function()
					api.marks.toggle()
					vim.cmd("norm j")
				end
				local mark_move_k = function()
					api.marks.toggle()
					vim.cmd("norm k")
				end

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				-- collapse all: W
				-- help: g?
				vim.keymap.set("n", "B", api.node.navigate.sibling.last, opts("Last sibling"))
				vim.keymap.set("n", "T", api.node.navigate.sibling.first, opts("First sibling"))
				vim.keymap.set("n", "J", mark_move_j, opts("Mark and move down"))
				vim.keymap.set("n", "K", mark_move_k, opts("Mark and move up"))
				vim.keymap.set("n", "by", mark_copy, opts("Copy File(s)"))
				vim.keymap.set("n", "bm", api.marks.bulk.move, opts("Move marked files"))
			end,
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
					resize_window = false,
				},
			},
			sync_root_with_cwd = true, -- changes the root directory to the worktree directory when changing worktrees with git-worktree
			git = {
				enable = true,
				ignore = false,
			},
			update_focused_file = {
				enable = true,
				update_root = false,
				ignore_list = {},
			},
		})
		-- kaymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
	end,
}
