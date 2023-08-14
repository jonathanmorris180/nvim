local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
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

-- recognize Salesforce files
vim.api.nvim_create_augroup("FileTypeGroup", {})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.cls", "*.trigger", "*.apex" },
	command = "set filetype=apex",
	group = "FileTypeGroup",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.soql" },
	command = "set filetype=soql",
	group = "FileTypeGroup",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.sosl" },
	command = "set filetype=sosl",
	group = "FileTypeGroup",
})

vim.lsp.set_log_level("debug")

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
