-- Adds spell checking to markdown files
-- Can be disabled with `:set nospell`
-- To navigate to the next misspelled word, use `]s`
-- To navigate to the previous misspelled word, use `[s`
-- To add a word to the dictionary, use `zg`
-- To mark a word as incorrect, use `zw`
-- To see suggestions, use `z=`
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

local utils = require("jonathan.core.utils")

local arrows = { [">>"] = "→", ["<<"] = "←", ["^^"] = "↑", ["VV"] = "↓" }
for key, val in pairs(arrows) do
	vim.cmd(string.format("iabbrev %s %s", key, val))
end

vim.keymap.set("n", "<C-]>", function()
	utils.set_markdown_header(1)
end, { desc = "Increase markdown header" })
vim.keymap.set("n", "<C-[>", function()
	utils.set_markdown_header(-1)
end, { desc = "Decrease markdown header" })
vim.keymap.set("n", "<C-o>", function()
	utils.toggle_markdown_bullet()
end, { desc = "Toggle markdown bullet (o looks like a bullet)" })
vim.keymap.set("v", "<C-b>", function()
	utils.markdown_bold()
end, { desc = "Make selection bold" }) -- TODO: Make a toggle
vim.keymap.set("v", "<C-i>", function()
	utils.markdown_italic()
end, { desc = "Make selection italic" })
vim.keymap.set("v", "<C-s>", function()
	utils.markdown_strikethrough()
end, { desc = "Strikethrough selection" })
