local is_tex_project = require("jonathan.core.utils").is_tex_project()
if not is_tex_project then
  return
end

vim.g.maplocalleader = " "
local keymap = vim.keymap

keymap.set("n", "K", ":VimtexDocPackage<CR>", { desc = "(Vimtex) Open texdoc documentation" })
