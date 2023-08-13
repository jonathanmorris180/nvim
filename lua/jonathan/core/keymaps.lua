vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>j", ":nohl<CR>") -- clears search highlights

-- save (:update only saves if there are changes)
keymap.set("n", "<leader>s", ":update<CR>")
-- :wa actually uses :update according to this: https://vi.stackexchange.com/questions/42066/updateall-command-to-update-all-files
keymap.set("n", "<leader>sa", ":wa<CR>")
keymap.set("n", "<leader>qq", ":qa!<CR>")
keymap.set("n", "<leader>q", ":q<CR>")

-- refresh from buffer
keymap.set("n", "<leader>r", ":e<CR>")

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

-- keep previous yank when pasting over highlight
keymap.set("x", "<leader>p", '"_dP')

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

keymap.set("n", "<leader>n", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>x", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>l", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>h", ":tabp<CR>") --  go to previous tab

-- allow copy to clipboard
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>yy", '"+yy')

----------------------
-- Plugin Keybinds
----------------------
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
