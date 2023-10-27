local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4 -- how many spaces the cursor moves when pressing <Tab>
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true -- react to indentation in the file

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

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
