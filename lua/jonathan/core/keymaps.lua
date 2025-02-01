local utils = require("jonathan.core.utils")

local keymap = vim.keymap

keymap.set("i", "jk", "<Esc>")
keymap.set("n", "<leader>j", ":nohl<CR>") -- clears search highlights

keymap.set("v", "<leader>p", '"_dP') -- paste without yanking

-- allow line movement when highlighted
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

local function format_json()
	vim.cmd(":set filetype=json")
	vim.cmd(":%!jq '.'")
end

local function format_file()
	vim.lsp.buf.format()
end

-- format xml
keymap.set("n", "<leader>fx", ":%!xmllint '%' --format<CR>")

-- format json
keymap.set("n", "<leader>fj", format_json)

-- format current file
keymap.set("n", "<leader>F", format_file)

-- duplicate selection below (above can easily be done without keymap)
keymap.set("v", "P", "y'>p")

-- Q to exit visual line mode
keymap.set("v", "q", "<Esc>")

-- keep cursor in position
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("n", "J", "mzJ`z")

-- disable Q
keymap.set("n", "Q", "<nop>")

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window
keymap.set("n", "<leader>on", ":vnew<CR>") -- open a new split window

-- tabs
keymap.set("n", "<leader>tn", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tl", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>th", ":tabp<CR>") --  go to previous tab

-- allow copy to clipboard
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>y", '"+y')

-- enable/disable diagnostics
keymap.set("n", "<leader>dd", ":DisableDiagnostics<CR>")
keymap.set("n", "<leader>de", ":EnableDiagnostics<CR>")

vim.api.nvim_create_user_command("DisableDiagnostics", function()
	vim.diagnostic.enable(false)
end, {})
vim.api.nvim_create_user_command("EnableDiagnostics", function()
	vim.diagnostic.enable()
end, {})

-- quickfix
keymap.set("n", "<leader>qo", "<CMD>copen<CR>") -- open the quickfix list
keymap.set("n", "<leader>qx", "<CMD>cclose<CR>") -- close the quickfix list
keymap.set("n", "<leader>qc", "<CMD>cexpr []<CR>") -- clear the quickfix list

-------------
-- Buffers --
-------------
keymap.set("n", "<leader>yp", ":Cppath<CR>") -- copy relative path of current buffer
keymap.set("n", "<leader>bd", ":%bd|e#<CR>") -- close all buffers except current
keymap.set("n", "<leader>n", ":bn<CR>") -- go to next buffer (in order of when they were opened)
keymap.set("n", "<leader>p", ":bp<CR>") -- go to previous buffer (in order of when they were opened)
keymap.set("n", "<leader>w", ":update<CR>") -- save (:update only saves if there are changes)
-- :wa actually uses :update according to this: https://vi.stackexchange.com/questions/42066/updateall-command-to-update-all-files
keymap.set("n", "<leader>sa", ":wa<CR>") -- save all buffers
keymap.set("n", "<leader>qq", ":qa!<CR>") -- quit all buffers
keymap.set("n", "<leader>c", ":q!<CR>") -- quit the current buffer
keymap.set("n", "<leader>r", ":e!<CR>") -- refresh buffer
keymap.set("n", "<Up>", "10<C-w>>") -- increase window width
keymap.set("n", "<Down>", "10<C-w><") -- decrease window width

---------------------
-- Plugin Keybinds --
---------------------
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Git
keymap.set("n", "<leader>gb", ":Git<Space>blame<CR>")
keymap.set("n", "<leader>gg", ":G<CR>") -- Opens the fugitive window (dd can be used for vertical diff, select a file in the fugitive window to exit)
keymap.set("n", "<leader>do", ":DiffviewOpen<CR>")
keymap.set("n", "<leader>dc", ":DiffviewClose<CR>")

-- yanky keymaps
keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
keymap.set("n", "H", "<Plug>(YankyCycleForward)")
keymap.set("n", "L", "<Plug>(YankyCycleBackward)")
keymap.set("n", "<leader>yh", "<CMD>YankyRingHistory<CR>")

-- toggle undo tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

---------------
-- Debugging --
---------------

keymap.set("n", "<leader>dt", ':lua require("dapui").toggle()<CR>')
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
keymap.set("n", "<leader>dr", ":lua require('dap').repl.open()<CR>")

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- markdown preview
keymap.set("n", "<leader>md", ":MarkdownPreview<CR>")
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>")

-- live server
keymap.set("n", "<leader>ls", ":LiveServerStart<CR>")
keymap.set("n", "<leader>lx", ":LiveServerStop<CR>")

-- switch from camelCase to snake_case and vice versa
vim.api.nvim_create_user_command("SwitchCase", utils.switch_case, {})
keymap.set("n", "<leader>sc", ":SwitchCase<CR>")

-- conditional file type for .cls files
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.cls" },
	callback = function()
		local is_tex_project = utils.is_tex_project()
		if not is_tex_project then
			vim.bo.filetype = "apex"
		end
	end,
})

-- cool commands to capture the output of a command
-- see here: https://www.reddit.com/r/neovim/comments/1g1xyi3/capture_the_command_output/
vim.keymap.set("n", "y:", function()
	local ok, input_cmd = pcall(vim.fn.input, {
		prompt = "(yank) :",
		default = "",
		completion = "command",
		cancelreturn = "",
	})
	if not ok or input_cmd == "" then
		return
	end
	local output = vim.api.nvim_exec2(input_cmd, { output = true }).output
	vim.fn.setreg(vim.v.register, output)
end)

vim.keymap.set("n", "<C-W>:", function()
	local ok, input_cmd = pcall(vim.fn.input, {
		prompt = "(capture) :",
		default = "",
		completion = "command",
		cancelreturn = "",
	})
	if not ok or input_cmd == "" then
		return
	end
	local output = vim.api.nvim_exec2(input_cmd, { output = true }).output
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
	vim.api.nvim_open_win(buf, true, {
		height = vim.o.cmdwinheight,
		split = "right",
		win = 0,
	})
end)
