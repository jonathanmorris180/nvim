return {
	"theprimeagen/git-worktree.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	config = function()
		local worktree = require("git-worktree")
		worktree.on_tree_change(function(op, metadata)
			print("worktree updated")
			if op == worktree.Operations.Switch then
				require("salesforce.org_manager"):get_org_info(true)
				vim.fn.system("tmux-windowizer " .. metadata.path)
				print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
			end
		end)
	end,
}
