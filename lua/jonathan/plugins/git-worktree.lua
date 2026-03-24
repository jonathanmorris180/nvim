return {
  "theprimeagen/git-worktree.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    local worktree = require("git-worktree")
    worktree.setup({
      clear_jumps_on_change = false, -- this is handled by auto-session, see https://github.com/ThePrimeagen/git-worktree.nvim/issues/13
      update_on_change = false,
    })
    worktree.on_tree_change(function(op, metadata)
      vim.notify("Worktree updated")
      if op == "switch" then
        require("jonathan.core.utils").refresh_project_lsp_config()
      end
    end)
  end,
}
