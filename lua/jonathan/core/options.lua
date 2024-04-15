local opt = vim.opt

-- file types
vim.filetype.add({
	extension = {
		cls = "apex",
		apex = "apex",
		trigger = "apex",
		soql = "soql",
		sosl = "sosl",
		page = "html",
		cmp = "html",
		auradoc = "html",
		design = "html",
	},
})

-- conditional file type for .cls files
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.cls" },
	callback = function()
		local is_tex_project = require("jonathan.core.utils").is_tex_project()
		if not is_tex_project then
			vim.bo.filetype = "apex"
		end
	end,
})

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation (see https://stackoverflow.com/questions/51995128/setting-autoindentation-to-spaces-in-neovim)
opt.tabstop = 2
opt.shiftwidth = 2 -- replicate value doesn't work from above post
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- undo
opt.swapfile = false
opt.backup = false
---@diagnostic disable-next-line: assign-type-mismatch
opt.undodir = os.getenv("HOME") .. "/.vim/.undo"
opt.undofile = true

-- line wrapping
opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- time before vim waits to trigger an event (after typing, for example)
opt.updatetime = 50

-- appearance
opt.scrolloff = 8 -- no fewer than 8 lines from bottom or top when you scroll down/up
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- makes backspace work correctly
opt.backspace = "indent,eol,start"

-- allows neovim to use the system clipboard
-- opt.clipboard:append("unnamedplus")

-- allow splitting horizontally and vertically
opt.splitright = true
opt.splitbelow = true
