local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = true

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
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
