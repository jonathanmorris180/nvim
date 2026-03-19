return {
  "theprimeagen/git-worktree.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    local worktree = require("git-worktree")
    local utils = require("jonathan.core.utils")
    worktree.setup({
      clear_jumps_on_change = false, -- this is handled by auto-session, see https://github.com/ThePrimeagen/git-worktree.nvim/issues/13
      update_on_change = false,
    })
    worktree.on_tree_change(function(op, metadata)
      local sock = vim.v.servername
      local session_id = utils.tmux_session_id()
      if not session_id then
        return
      end
      vim.fn.system({ "tmux", "set-option", "-q", "-t", session_id, "@nvim_socket", sock }) -- in case the server name changes after updating the worktree
      vim.notify("Worktree updated")
    end)
  end,
}
