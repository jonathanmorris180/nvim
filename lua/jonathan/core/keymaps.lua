vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>j", ":nohl<CR>") -- clears search highlights

-- open blame
keymap.set("n", "<leader>gb", ":Git<Space>blame<CR>")

-- allow line movement when highlighted
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- toggle undo tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- keep cursor in middle
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- delete without losing previous yank
keymap.set("n", "<leader>d", '"_d')
keymap.set("v", "<leader>d", '"_d')

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
keymap.set("n", "<leader>yy", '"+yy')

-------------
-- Buffers --
-------------
keymap.set("n", "<leader>yp", ":Cppath<CR>") -- copy relative path of current buffer
keymap.set("n", "<leader>bd", ":%bd|e#<CR>") -- close all buffers except current
keymap.set("n", "<leader>n", ":bn<CR>") -- go to next buffer
keymap.set("n", "<leader>p", ":bp<CR>") -- go to previous buffer
keymap.set("n", "<leader>w", ":update<CR>") -- save (:update only saves if there are changes)
-- :wa actually uses :update according to this: https://vi.stackexchange.com/questions/42066/updateall-command-to-update-all-files
keymap.set("n", "<leader>sa", ":wa<CR>") -- save all buffers
keymap.set("n", "<leader>qq", ":qa!<CR>") -- quit all buffers
keymap.set("n", "<leader>c", ":q!<CR>") -- quit the current buffer
keymap.set("n", "<leader>r", ":e!<CR>") -- refresh buffer
keymap.set("n", "<Up>", "10<C-w>>") -- increase window width
keymap.set("n", "<Down>", "10<C-w><") -- decrease window width

----------------------
-- Plugin Keybinds
----------------------
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
-- <C-q> opens the quickfix list (already mapped)
keymap.set("n", "<C-f>", "<CMD>Telescope find_files<CR>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<CMD>Telescope live_grep<CR>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<CMD>Telescope grep_string<CR>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<CMD>Telescope buffers sort_mru=true<CR>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<CMD>Telescope help_tags<CR>") -- list available help tags
keymap.set("n", "<leader>fk", "<CMD>Telescope keymaps<CR>") -- list available help tags
keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>") -- live grep args extension
keymap.set("n", "<leader>fr", "<CMD>Telescope resume<CR>") -- resumes the previous picker (sea

-- quickfix
keymap.set("n", "<leader>qo", "<CMD>copen<CR>") -- open the quickfix list
keymap.set("n", "<leader>qx", "<CMD>cclose<CR>") -- close the quickfix list
keymap.set("n", "<leader>qc", "<CMD>cexpr []<CR>") -- clear the quickfix list

-- debugging
keymap.set("n", "<leader>dt", ':lua require("dapui").toggle()<CR>')
keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")

-- SFDX
vim.api.nvim_create_user_command("SfdxDiffFile", function()
	local path = vim.fn.expand("%:p")
	local command = "SFDX_DIFF_JSON=$(sfdx force:source:diff -p "
		.. path
		.. " --json) && git diff $(echo ${SFDX_DIFF_JSON} | jq '.result.remote' -r) $(echo ${SFDX_DIFF_JSON} | jq '.result.local' -r)"
	local tmux = require("harpoon.tmux")
	tmux.sendCommand("{next}", command)
	tmux.gotoTerminal("{next}")
end, {})
keymap.set("n", "<leader>df", ":SfdxDiffFile<CR>")
