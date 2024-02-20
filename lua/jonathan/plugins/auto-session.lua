return {
	"rmagatti/auto-session",
	lazy = true,
	config = function()
		vim.notify("starting auto-session")
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			auto_save_enabled = true,
			auto_restore_enabled = true,
			auto_session_use_git_branch = true,
			pre_save_cmds = {
				"NvimTreeClose", -- helps nvim-tree work well with auto-session and git-worktree
			},
			post_restore_cmds = {
				"NvimTreeOpen", -- helps nvim-tree work well with auto-session and git-worktree
			},

			cwd_change_handling = {
				post_cwd_changed_hook = function()
					require("lualine").refresh()
				end,
			},
		})
	end,
	init = function()
		-- taken from: https://github.com/rmagatti/auto-session/issues/223
		local autocmd = vim.api.nvim_create_autocmd

		local lazy_did_show_install_view = false

		local function auto_session_restore()
			-- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
			vim.schedule(function()
				require("auto-session").AutoRestoreSession()
			end)
		end

		autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				local lazy_view = require("lazy.view")

				if lazy_view.visible() then
					-- if lazy view is visible do nothing with auto-session
					lazy_did_show_install_view = true
				else
					-- otherwise load (by require'ing) and restore session
					auto_session_restore()
				end
			end,
		})

		autocmd("WinClosed", {
			pattern = "*",
			callback = function(ev)
				local lazy_view = require("lazy.view")

				-- if lazy view is currently visible and was shown at startup
				if lazy_view.visible() and lazy_did_show_install_view then
					-- if the window to be closed is actually the lazy view window
					if ev.match == tostring(lazy_view.view.win) then
						lazy_did_show_install_view = false
						auto_session_restore()
					end
				end
			end,
		})
	end,
}
