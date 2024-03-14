local apex = {
	icon = "󰢎",
	color = "#009EDB",
	cterm_color = "65", -- seems to be the default value
	name = "Apex",
}

local visualforce = {
	icon = "",
	color = "#4E9A06",
	cterm_color = "71",
	name = "Visualforce",
}

local aura = {
	icon = "",
	color = "#4E9A06",
	cterm_color = "71",
	name = "Aura",
}

return {
	"nvim-tree/nvim-web-devicons",
	opts = {
		override = {
			apex = apex,
			cls = apex,
			page = visualforce,
			cmp = aura,
			auradoc = aura,
			design = aura,
		},
	},
}
