return {
	"glacambre/firenvim",
	build = ":call firenvim#install(0)",
	config = function()
		vim.g.firenvim_config = {
			globalSettings = { alt = "all" },
			localSettings = {
				[".*"] = {
					cmdline = "neovim",
					content = "text",
					priority = 0,
					selector = "textarea",
					takeover = "never", -- don't automatically create a Neovim instance inside a text box - Cmd+e to open it
				},
			},
		}
	end,
}
