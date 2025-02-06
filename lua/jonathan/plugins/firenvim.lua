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
				[".*atlassian.net.*"] = {
					content = "html", -- allows for editing Jira tickets while keeping formatting (don't try and format the file though - it has to stay in the weird minified state)
					priority = 1,
				},
			},
		}
	end,
}
