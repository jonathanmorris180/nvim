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

vim.api.nvim_create_autocmd("BufWritePre", {
	-- inspired by https://www.reddit.com/r/neovim/comments/15tpl36/format_your_code_using_prettier_without_nullls/
	desc = "Format apex files on save with prettier",
	group = vim.api.nvim_create_augroup("PrettierApex", {}),
	callback = function(opts)
		if vim.bo[opts.buf].filetype == "apex" then
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return nil
			end
			local fmt_command = "%!npx prettier --stdin-filepath %"
			local cursor = vim.api.nvim_win_get_cursor(0)
			vim.cmd(fmt_command)
			-- In case formatting got rid of the line we came from.
			cursor[1] = math.min(cursor[1], vim.api.nvim_buf_line_count(0))
			vim.api.nvim_win_set_cursor(0, cursor)
		end
	end,
})

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
