local keymap = vim.keymap

keymap.set("n", "<leader>gr", "<CMD>!go run %<CR>", { desc = "(Go) Run current file" })
