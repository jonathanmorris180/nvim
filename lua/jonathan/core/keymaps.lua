local utils = require("jonathan.core.utils")

local keymap = vim.keymap

keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>j", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("v", "<leader>p", '"_dP', { desc = "Paste without yanking" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

local function format_json()
	vim.cmd(":set filetype=json")
	vim.cmd(":%!jq '.'")
end

local function format_file()
	vim.lsp.buf.format()
end

keymap.set("n", "<leader>fx", ":%!xmllint '%' --format<CR>", { desc = "Format XML" })

keymap.set("n", "<leader>fj", format_json, { desc = "Format JSON" })

keymap.set("n", "<leader>F", format_file, { desc = "Format file" })

keymap.set("v", "P", "y'>p", { desc = "Duplicate selection below" })

keymap.set("v", "q", "<Esc>", { desc = "Exit visual line mode" })

-- keep cursor in position
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move half page down but center cursor" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move half page up but center cursor" })
keymap.set("n", "n", "nzzzv", { desc = "Next result with cursor centered" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous result with cursor centered" })
keymap.set("n", "J", "mzJ`z", { desc = "Join line beneath with current line but keep cursor in place" })

-- disable Q
keymap.set("n", "Q", "<nop>", { desc = "Do nothing" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make split windows equal width & height" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" })

-- tabs
keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tl", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>th", ":tabp<CR>", { desc = "Go to previous tab" })

-- allow copy to clipboard
keymap.set("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap.set("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- enable/disable diagnostics
keymap.set("n", "<leader>dd", ":DisableDiagnostics<CR>", { desc = "Disable diagnostics" })
keymap.set("n", "<leader>de", ":EnableDiagnostics<CR>", { desc = "Enable diagnostics" })

vim.api.nvim_create_user_command("DisableDiagnostics", function()
	vim.diagnostic.enable(false)
end, {})
vim.api.nvim_create_user_command("EnableDiagnostics", function()
	vim.diagnostic.enable()
end, {})

-- quickfix
keymap.set("n", "<leader>qo", "<CMD>copen<CR>", { desc = "Open the quickfix list" })
keymap.set("n", "<leader>qx", "<CMD>cclose<CR>", { desc = "Close the quickfix list" })
keymap.set("n", "<leader>qc", "<CMD>cexpr []<CR>", { desc = "Clear the quickfix list" })

-------------
-- Buffers --
-------------
keymap.set("n", "<leader>yp", ":Cppath<CR>", { desc = "Copy relative path of current buffer to the system clipboard" })
keymap.set("n", "<leader>bd", ":%bd|e#<CR>", { desc = "Close all buffers except current" })
keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Go to next buffer (in order of when they were opened)" })
keymap.set("n", "<leader>p", ":bp<CR>", { desc = "Go to previous buffer (in order of when they were opened)" })
keymap.set("n", "<leader>w", ":update<CR>", { desc = "Save (:update only saves if there are changes)" })
-- :wa actually uses :update according to this: https://vi.stackexchange.com/questions/42066/updateall-command-to-update-all-files
keymap.set("n", "<leader>sa", ":wa<CR>", { desc = "Save all buffers" })
keymap.set("n", "<leader>qq", ":qa!<CR>", { desc = "Quit all buffers" })
keymap.set("n", "<leader>c", ":q!<CR>", { desc = "Close the current buffer" })
keymap.set("n", "<leader>r", ":e!<CR>", { desc = "Refresh the current buffer" })
keymap.set("n", "<Up>", "10<C-w>>", { desc = "Increase window width" })
keymap.set("n", "<Down>", "10<C-w><", { desc = "Decrease window width" })

---------------------
-- Plugin Keybinds --
---------------------
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "(nvim-tree) Toggle nvim-tree" })

-- Git
keymap.set("n", "<leader>gb", ":Git<Space>blame<CR>", { desc = "(Fugitive) Open git blame" })
keymap.set(
	"n",
	"<leader>gg",
	":G<CR>",
	{ desc = "(Fugitive) Opens the fugitive window (dd can be used for vertical diff)" }
)
-- Note that it seems there are no plans to add an equivalent of "git add ." to fugitive: https://github.com/tpope/vim-fugitive/issues/2366
keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "(Diffview) Open diffview (conflicts)" })
keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "(Diffview) Close diffview (conflicts)" })

-- yanky keymaps
keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "(Yanky) Paste" })
keymap.set("n", "H", "<Plug>(YankyCycleForward)", { desc = "(Yanky) Cycle next pasted item" })
keymap.set("n", "L", "<Plug>(YankyCycleBackward)", { desc = "(Yanky) Cycle previous pasted item" })
keymap.set("n", "<leader>yh", "<CMD>YankyRingHistory<CR>", { desc = "(Yanky) Open yanky history" })

-- toggle undo tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "(Undotree) Toggle undotree" })

---------------
-- Debugging --
---------------

keymap.set("n", "<leader>dt", ':lua require("dapui").toggle()<CR>', { desc = "(nvim-dap-ui) Toggle dapui" })
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "(nvim-dap) Set breakpoint" })
keymap.set("n", "<leader>dr", ":lua require('dap').repl.open()<CR>", { desc = "(nvim-dap) Open REPL" })

vim.api.nvim_create_user_command("Cppath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- markdown preview
keymap.set("n", "<leader>md", ":MarkdownPreview<CR>", { desc = "(markdown-preview) Markdown preview" })
keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "(markdown-preview) Stop markdown preview" })

-- switch from camelCase to snake_case and vice versa
vim.api.nvim_create_user_command("SwitchCase", utils.switch_case, {})
keymap.set("n", "<leader>sc", ":SwitchCase<CR>", { desc = "Switch from camelCase to snake_case and back" })

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

-- set filetype to markdown for all firenvim GitHub buffers
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "github.com_*.txt",
	command = "set filetype=markdown",
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
end, { desc = "Yank output of command mode command" })

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
end, { desc = "Open output of command-mode command in new buffer" })
