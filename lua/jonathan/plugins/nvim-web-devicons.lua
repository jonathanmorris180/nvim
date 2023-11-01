local apex = {
	icon = "󰢎",
	color = "#009EDB",
	cterm_color = "65", -- seems to be the default value
	name = "Apex",
}

return {
	"nvim-tree/nvim-web-devicons",
	opts = {
		override = {
			apex = apex,
			cls = apex,
		},
	},
}
