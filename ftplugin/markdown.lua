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
end)
vim.keymap.set("n", "<C-[>", function()
	utils.set_markdown_header(-1)
end)
